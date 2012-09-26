﻿using System;
using System.Linq;
using OpenEnvironment.gov.epa.cdx;
using Ionic.Zip;
using System.IO;
using System.Xml.Linq;
using OpenEnvironment.App_Logic.DataAccessLayer;
using OpenEnvironment.App_Logic.BusinessLogicLayer;


namespace OpenEnvironment
{
    public partial class RefData : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
                
        protected void btnGetRefData_Click(object sender, EventArgs e)
        {
            //******* ORGANIZATION LEVEL *********************
            GetAndStoreRefTable("Tribe", "Code", "Name", null);

            //******* PROJECT LEVEL *********************
            GetAndStoreRefTable("SamplingDesignType", "Code", "Code", null);

            //******* MON LOC LEVEL *********************
            GetAndStoreRefTable("County", "CountyFIPSCode", "CountyName", "County");
            GetAndStoreRefTable("Country", "Code", "Name", null);
            GetAndStoreRefTable("HorizontalCollectionMethod", "Name", "Description", null);
            GetAndStoreRefTable("HorizontalCoordinateReferenceSystemDatum", "Name", "Description", null);
            GetAndStoreRefTable("MonitoringLocationType", "Name", "Name", null);
            GetAndStoreRefTable("State", "Code", "Name", null);
            GetAndStoreRefTable("VerticalCollectionMethod", "Name", "Name", null);
            GetAndStoreRefTable("VerticalCoordinateReferenceSystemDatum", "Name", "Description", null);
            GetAndStoreRefTable("WellFormationType", "Name", "Name", null);
            GetAndStoreRefTable("WellType", "Name", "Name", null);
            
            //******* ACTIVITY/RESULTS LEVEL *************            
            GetAndStoreRefTable("ActivityMedia", "Name", "Name", null);
            GetAndStoreRefTable("ActivityMediaSubdivision", "Name", "Name", null);
            GetAndStoreRefTable("ActivityType", "Code", "Description", null);
            GetAndStoreRefTable("ActivityRelativeDepth", "Name", "Name", null);
            GetAndStoreRefTable("AnalyticalMethod", "ID", "Name", "AnalMethod");
            GetAndStoreRefTable("Characteristic", "Name", "Name", "Characteristic");
            GetAndStoreRefTable("MeasureUnit", "Code", "Description", null);
            GetAndStoreRefTable("NetType", "Name", "Name", null);
            GetAndStoreRefTable("ResultDetectionCondition", "Name", "Name", null);
            GetAndStoreRefTable("ResultLaboratoryComment", "Code", "Description", null);
            GetAndStoreRefTable("ResultMeasureQualifier", "Code", "Description", null);
            GetAndStoreRefTable("ResultSampleFraction", "Name", "Description", null);
            GetAndStoreRefTable("ResultStatus", "Name", "Description", null);
            GetAndStoreRefTable("ResultTemperatureBasis", "Name", "Description", null);
            GetAndStoreRefTable("ResultTimeBasis", "Name", "Description", null);
            GetAndStoreRefTable("ResultValueType", "Name", "Description", null);
            GetAndStoreRefTable("ResultWeightBasis", "Name", "Description", null);
            GetAndStoreRefTable("SampleCollectionEquipment", "Name", "Name", null);
            GetAndStoreRefTable("SampleContainerColor", "Name", "Description", null);
            GetAndStoreRefTable("SampleContainerType", "Name", "Description", null);
            GetAndStoreRefTable("SampleTissueAnatomy", "Name", "Name", null);
            GetAndStoreRefTable("Taxon", "Name", "Name", null);
            GetAndStoreRefTable("TimeZone", "Code", "Name", null);

        }

        protected void grdRef_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int RefID = e.CommandArgument.ToString().ConvertOrDefault<int>();

            if (e.CommandName == "Deletes")
            {
                db_Ref.UpdateT_WQX_REF_DATAByIDX(RefID, null, null, false);
            }

        }

        protected void ddlRef_SelectedIndexChanged(object sender, EventArgs e)
        {
            grdRef.PageIndex = 0;

            //todo: display characteristic
            if (ddlRef.SelectedValue != "Characteristic")
            { }
            else
            { }
        }

        protected void GetAndStoreRefTable(string tableName, string ValueString, string TextString, string CustomParseName)
        {
            //get file
            DomainValuesService d = new DomainValuesService();
            byte[] b = d.GetDomainValues(tableName);

            //cleanup any previous files
            if (File.Exists(Server.MapPath("~/tmp/Results.xml")))
                File.Delete(Server.MapPath("~/tmp/Results.xml"));

            using (System.IO.Stream stream = new System.IO.MemoryStream(b))
            {
                using (var zip = ZipFile.Read(stream))
                {
                    foreach (var entry in zip)
                    {
                        entry.Extract(Server.MapPath("~/tmp"));
                    }
                }
            }

            XDocument xdoc = XDocument.Load(Server.MapPath("~/tmp/Results.xml"));

            // ***************** DEFAULT PARSING **************************************
            if (CustomParseName == null)
            {
                var lv1s = from lv1 in xdoc.Descendants("{http://www.exchangenetwork.net/schema/wqx/2}WQXElementRow")
                            select new
                            {
                                ID = lv1.Descendants("{http://www.exchangenetwork.net/schema/wqx/2}WQXElementRowColumn").First(ID2 => ID2.Attribute("colname").Value == ValueString).Attribute("value"),
                                Text = lv1.Descendants("{http://www.exchangenetwork.net/schema/wqx/2}WQXElementRowColumn").First(Text2 => Text2.Attribute("colname").Value == TextString).Attribute("value"),
                            };

                foreach (var lv1 in lv1s)
                {
                    db_Ref.InsertOrUpdateT_WQX_REF_DATA(tableName, lv1.ID.Value, lv1.Text.Value, null);
                }
            }


            // ***************** DEFAULT PARSING **************************************
            if (CustomParseName == "Characteristic")
            {
                var lv1s = from lv1 in xdoc.Descendants("{http://www.exchangenetwork.net/schema/wqx/2}WQXElementRow")
                           select new
                           {
                               ID = lv1.Descendants("{http://www.exchangenetwork.net/schema/wqx/2}WQXElementRowColumn").First(ID2 => ID2.Attribute("colname").Value == ValueString).Attribute("value"),
                           };

                foreach (var lv1 in lv1s)
                {
                    db_Ref.InsertOrUpdateT_WQX_REF_CHARACTERISTIC(lv1.ID.Value, null, null, null, true);
                }
            }


        }

        protected void grdRef_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
        {
            grdRef.PageIndex = e.NewPageIndex;
        }

    }
}