﻿using System;
using System.Collections.Generic;
using System.Web;
using Owin;
using Microsoft.Owin.Security.Cookies;
using System.Configuration;
using System.IdentityModel.Tokens;
using Microsoft.Owin.Security.OpenIdConnect;
using System.Security.Claims;
using OpenEnvironment.App_Logic.DataAccessLayer;
using System.Threading.Tasks;

namespace OpenEnvironment
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //IdentityServer configuration settings
            if (ConfigurationManager.AppSettings["UseIdentityServer"] == "true")
            {
                JwtSecurityTokenHandler.InboundClaimTypeMap = new Dictionary<string, string>();

                app.UseCookieAuthentication(new CookieAuthenticationOptions
                {
                    AuthenticationType = "Cookies",
                    ExpireTimeSpan = System.TimeSpan.FromMinutes(60),
                });

                app.UseOpenIdConnectAuthentication(new OpenIdConnectAuthenticationOptions
                {
                    //IMPLICIT 
                    ClientId = "open_waters",
                    Authority = ConfigurationManager.AppSettings["IdentityServerAuthority"],      //"http://localhost:3892/",  //ID Server
                    RedirectUri = ConfigurationManager.AppSettings["IdentityServerRedirectURI"],  //"http://localhost:1244/signinoidc",  , // 
                    PostLogoutRedirectUri = ConfigurationManager.AppSettings["IdentityServerPostLogoutURI"], //"http://localhost:1244/signoutcallbackoidc",
                    ResponseType = "id_token",
                    UseTokenLifetime = false,

                    SignInAsAuthenticationType = "Cookies",
                    Scope = "openid profile email",

                    TokenValidationParameters = {
                        NameClaimType = "name"
                    },
                    Notifications = new OpenIdConnectAuthenticationNotifications()
                    {
                        SecurityTokenValidated = (context) =>
                        {
                            //grab information about User
                            ClaimsIdentity _identity = context.AuthenticationTicket.Identity;
                            var UserID_portal = _identity.FindFirst("sub").Value;
                            int UserIDX = 0;

                            //check if user with this email already in system
                            T_OE_USERS t = db_Accounts.GetT_VCCB_USERByEmail(_identity.Name);
                            if (t == null)
                            {
                                //insert new USERS table if not yet there
                                UserIDX = db_Accounts.CreateT_OE_USERS(_identity.Name, "unused", "unused", "temp", "temp", _identity.Name, true, false, System.DateTime.Now, null, null, "portal");

                                //Add user to GENERAL USER Role
                                db_Accounts.CreateT_VCCB_USER_ROLE(3, UserIDX, "system");
                            }
                            else
                            {
                                //update existing user record
                                UserIDX = t.USER_IDX;

                                //switch "User.Identity.Name" to the username
                                context.AuthenticationTicket.Identity.RemoveClaim(_identity.FindFirst("name"));
                                Claim nameClaim = new Claim("name", t.USER_ID, ClaimValueTypes.String, "LocalAuthority");
                                context.AuthenticationTicket.Identity.AddClaim(nameClaim);
                            }


                            if (UserIDX > 0)
                            {
                                //now add UserIDX to claims 
                                Claim userIDXClaim = new Claim("UserIDX", UserIDX.ToString(), ClaimValueTypes.Integer, "LocalAuthority");
                                context.AuthenticationTicket.Identity.AddClaim(userIDXClaim);
                            }
                            else
                                throw new System.IdentityModel.Tokens.SecurityTokenValidationException();


                            //delete all orgs for this user to Inactive
                            db_WQX.DeleteT_WQX_USER_ORGS_AllByUserIDX(UserIDX);

                            //now handling jurisdiction associations
                            var authorizedOrgs = _identity.FindAll("open_waters");
                            foreach (var org in authorizedOrgs)
                            {
                                string[] org_array = org.Value.Split(';');

                                T_WQX_ORGANIZATION o = db_WQX.GetWQX_ORGANIZATION_ByID(org_array[0]);
                                if (o != null)
                                {
                                    db_WQX.InsertT_WQX_USER_ORGS(o.ORG_ID, UserIDX, org_array[1] == "True" ? "A" : "U");
                                }
                            }

                            return Task.FromResult(0);
                        }
                    }

                    //HYBRID values
                    //AuthenticationScheme = "oidc",    //--------
                    //SignInScheme = "cookie",   //--------
                    //Authority = "http://localhost:5003/",  //--------
                    //RequireHttpsMetadata = false,    //--------
                    //ClientId = "mvc",      //--------
                    //ClientSecret = "superSecretPassword",   //--------
                    //ResponseType = "code id_token",    //--------
                    //Scope = {
                    //    "offline_access",
                    //    "openid",
                    //    "profile"
                    //},
                    //GetClaimsFromUserInfoEndpoint = true,   //--------
                    //SaveTokens = true
                });

            }

        }



    }
}