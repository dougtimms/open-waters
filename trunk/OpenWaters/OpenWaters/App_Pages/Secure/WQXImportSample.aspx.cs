﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenEnvironment.App_Logic.DataAccessLayer;
using OpenEnvironment.App_Logic.BusinessLogicLayer;

namespace OpenEnvironment
{
    public partial class WQXImportSample : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["OrgID"] == null)
                Response.Redirect("~");

            if (!IsPostBack)
            {
                //display left menu as selected
                ContentPlaceHolder cp = this.Master.Master.FindControl("MainContent") as ContentPlaceHolder;
                HyperLink hl = (HyperLink)cp.FindControl("lnkImport");
                if (hl != null) hl.CssClass = "leftMnuBody sel";

                PopulateGrid();
            }
        }

        private void PopulateGrid()
        {
            grdImport.DataSource = db_WQX.GetWQX_IMPORT_TEMP_SAMP_RESULT_Disp(User.Identity.Name);
            grdImport.DataBind();
            grdImport.RemoveEmptyColumns(true, "Include in Import");
        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            string OrgID = "";

            db_WQX.SP_ImportActivityFromTemp(User.Identity.Name, chkWQXImport.Checked == true ? "Y" : "N");

            //List<int> SelectedSamples = new List<int>();
            //List<int> SelectedResults = new List<int>();
            //List<int> DistinctSamples = new List<int>();

            ////first loop through just to get distinct selected samples and results
            //foreach (GridViewRow row in grdImport.Rows)
            //{
            //    CheckBox check = (CheckBox)row.FindControl("chkImport");

            //    if (check.Checked)
            //    {
            //        HiddenField hdSamp = row.FindControl("hdnTempSampleIDX") as HiddenField;
            //        HiddenField hdResult = row.FindControl("hdnTempSampleIDX") as HiddenField;

            //        int TempSampID = hdSamp.Value.ConvertOrDefault<int>();
            //        int TempResultID = hdResult.Value.ConvertOrDefault<int>();

            //        SelectedSamples.Add(TempSampID);
            //        SelectedResults.Add(TempResultID);
            //    }
            //}

            ////get distinct listing of TEMP SAMPLE IDX
            //DistinctSamples = SelectedSamples.Distinct().ToList();

            ////now loop through samples
            //foreach (int SampID in DistinctSamples)
            //{
            //    T_WQX_IMPORT_TEMP_SAMPLE s = db_WQX.GetWQX_IMPORT_TEMP_SAMPLE_ByID(SampID);
            //    if (s != null)
            //    {
            //        OrgID = s.ORG_ID;

            //        int NewActivityID = db_WQX.InsertOrUpdateWQX_ACTIVITY(s.ACTIVITY_IDX, s.ORG_ID, s.PROJECT_IDX, s.MONLOC_IDX, s.ACTIVITY_ID, s.ACT_TYPE, s.ACT_MEDIA, s.ACT_SUBMEDIA, s.ACT_START_DT,
            //            s.ACT_END_DT, s.ACT_TIME_ZONE, s.ACT_COMMENT, "U", true, chkWQXImport.Checked, User.Identity.Name);
                        
            //        List<T_WQX_IMPORT_TEMP_RESULT> rs = db_WQX.GetWQX_IMPORT_TEMP_RESULT_ByTempSampIDX(SampID);
            //        foreach (T_WQX_IMPORT_TEMP_RESULT r in rs)
            //        {
            //            if (SelectedResults.Contains(r.TEMP_RESULT_IDX))
            //                // db_WQX.InsertOrUpdateT_WQX_RESULT(null, NewActivityID, r.CHAR_NAME, r.RESULT_MSR, r.RESULT_MSR_UNIT, r.ANALYTIC_METHOD_IDX, r.DETECTION_LIMIT, r.RESULT_COMMENT, null, null, null, null, User.Identity.Name);
            //        }
            //    }
            //}

            grdImport.Visible = false;
            btnSample.Visible = true;
            btnImport.Visible = false;
            btnCancel.Visible = false;
            pnlFilter.Visible = false;

            db_WQX.DeleteT_WQX_IMPORT_TEMP_SAMPLE(User.Identity.Name);

            //update import log
            db_Ref.UpdateWQX_IMPORT_LOG_MarkPendingSampImportAsComplete(OrgID);

            lblMsg.Text = "All selected data has been imported.";

        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            //delete first
            int SuccID = db_WQX.DeleteT_WQX_IMPORT_TEMP_SAMPLE(User.Identity.Name);

            //then redirect
            Response.Redirect("~/App_Pages/Secure/WQXImport.aspx");
        }

        protected Boolean VerifyCheck(object r)
        {
            string s = r.ConvertOrDefault<string>();
            if (s == "P")
                return true;
            else
                return false;
        }

        protected void grdImport_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (DataBinder.Eval(e.Row.DataItem, "IMPORT_STATUS_CD") != null)
                {
                    if (DataBinder.Eval(e.Row.DataItem, "IMPORT_STATUS_CD").ToString() == "F")
                        e.Row.BackColor = System.Drawing.Color.LightPink;
                    else
                        e.Row.BackColor = System.Drawing.Color.LightGreen;
                }
            }
        }

        protected void btnSample_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/App_Pages/Secure/WQXActivity.aspx");
        }

        protected void grdImport_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdImport.PageIndex = e.NewPageIndex;
            PopulateGrid();
        }


    }
}