# Open Waters: Water Quality Data Management System

![http://open-environment.org/images/OpenWatersLogo.png](http://open-environment.org/images/OpenWatersLogo.png)

## What is Open Waters?
Open Waters is web-based water quality data management software that helps people track monitoring locations, projects, samples, and results. Open Waters is intended for Tribal and State water quality data managers who collect and manage water quality data, and have the need to submit this data to EPA's WQX program. Open Waters is unique in that people can manage their data locally, but submission to EPA is completely automated and handled behind-the-scenes, thus eliminating the burden of separate data submission to EPA. This makes it ideal for agencies who would rather focus their time and energy on data collection and analysis. Plus, Open Waters is completely free and open source. Open Waters has been in use since 2012 and is actively used by several agencies.

## File Downloads
* [**Full Installation Package - Version 1.9.8**](http://www.open-environment.org/downloads/OpenWatersFullInstall_v1.9.8.zip)
* [**Patch Installation Package - Version 1.9**](http://www.open-environment.org/downloads/OpenWatersPatchOnly_v1.9.zip) (only use if upgrading from version v1.8 to v1.9x)
* [**User's Guide / Installation Guide**](https://github.com/open-environment/open-waters/raw/master/OpenWaters/OpenWaters/App_Docs/UsersGuide.docx)

## Open Waters Features

* **Water Quality Data Management:** Manage monitoring locations, projects, samples & results. This includes chemical results, field data, and biological metrics/indices.
* **Bulk Data Import:** Samples, results, monitoring locations, and metrics can be bulk imported from your favorite spreadsheet program, saving time on data entry. You can define you own import templates, or use Excel templates provided by Open Waters.
* **Automatic WQX Submission:** Data is automatically submitted to EPA’s WQX program (http://www.epa.gov/storet/wqx/) as it is entered. But you can still control which data is shared with EPA and which stays locally.
* **Data Retrieval From WQX:** Does your organization already have data stored at EPA-WQX? Open Waters lets you download this data to the Open Waters database, which is a handy way to quickly setup you data locally.
* **Reference Data Synchronization:** Reference data (e.g. Pollutant names, Taxonomic names, analytical methods, etc) are fully synchronized with EPA’s reference data, ensuring that submissions will not fail due to mismatches in reference values.
* **Mapping:** View monitoring locations geospatially and see latest sampling results. Publish public map.
* **Charting:** Time series and monitoring location trend charts can be generated with a variety of options.
* **Security:** Role-based application security and additional layered security measures to ensure data security.
* **Multi-Organization Support:** Multiple agencies (aka organizations) can share the same installation; all data is segmented by Organization.
* **Open Source:** Application is free to use, free to share, and free to modify, under the GNU GPL v3 license.


## More Information and Example Screens
* Additional product details: http://open-environment.org/open-waters
* Email: info@open-environment.org

## Prerequisites
* **Web Server**
  * Windows Server 2008 or later (IIS 7.5 or later)
  * .NET Framework 4.6.1
  * web server can communicate with Internet and Database (no firewall prohibiting access to EPA’s WQX server)
* **Database Server**
  * SQL Server 2012 or later (Express edition is OK)


## Change Log
* **5/27/2020 - Version 1.9.9(b):**
    * Pulling reference data from EPA - user can now set EPA reference data API URL in Global Settings 
* **10/27/2017 - Version 1.9.9:**
    * Monitoring Location Edit Page - added the following changes: 
        * Add ability to select location from map
        * Added Aquifer field
        * Bug fix: Cancel button now working when validation fails
        * Bug fix: County drop-down now correctly filtered by State
    * All maps: properly center map on monitoring locations
    * Public map now filters sites based on selected Organization
    * (Optional) Integration with Tribal Services Portal github.com/tribal-svc-portal (allows Single-Sign On across multiple applications)
* **1/13/2017 - Version 1.9.8:**
    * Major streamlining to data import module and data import configuration
    * Charting: new chart type (Monitoring Location Averages)
    * Charting: add second characteristic option for time series chart
    * Expanded Import Translation feature to all Activity/Result columns 
    * Crosstab import: add ability to import activity depth  
    * Add import of activity metrics
    * Monitoring Location data import: add ability to cancel import
    * Increase length of import error message
    * Add ActivityMetricType to reference data pull from EPA
* **11/9/2016 - Version 1.9.7:**
    * Add Assessment Report module, including submission to EPA ATTAINS
    * Added biological monitoring import 
    * Fix error when importing Lab Analysis Date or Lab Sample Prep date and leaving blank
    * Fix error on activity delete.
    * Improve speed of file download at WQX History page.
* **7/9/2016 - Version 1.9.5:**
    * Streamline WQX submission service for better reliability (less starting/stopping of windows service, and only perform CDX authentication test for organizations with pending data)
* **6/2/2016 - Version 1.9.3:**
    * Fixed a data validation error when submitting results labeled PBQL
* **5/5/2016 - Version 1.9.2:**
    * Updated Terms and Conditions
    * Added Description field to Admin --> Global Settings page
    * Three new global settings: Hosting Organization Name, Registration Message, and Notify Register
    * Added an option to have the site administrator get automatically emailed any time a new user registers an account
    * Added an option to display custom message on registration page
* **4/3/2016 - Version 1.9.1:**
    * When importing using cross tab, added ability to specify default Sample Collection Equipment and Collection Method
    * New validation check when importing samples: if activity type includes "Sample", then Sample Collection Method and Equipments are required
    * Improved import template configuration screen: now when specifying hard coded fields, you can select reference data from drop-down instead of typing in
* **3/25/2016 - Version 1.9:**
    * When importing using cross tab, now only validates a result if a result value is reported
    * When importing using cross tab, warn if activity ID already exists
    * When importing using traditional sample template, column headers no longer must be case sensitive.
    * When importing using traditional sample template, sample preparation date and time can now be stored in separate columns (or combined in a single column)
    * When importing using traditional sample template, analysis start date and time can now be stored in separate columns (or combined in a single column)
    * Automatically remove commas (e.g. thousand separators) when importing result values
    * Organizations can now specify a default lower and upper quantitation limit for each characteristic, which is then automatically applied when PABL or PBQL is reported
    * Organizations can now specify a default analytical method for each characteristic, which is then automatically applied if none is explicitly included in an import file
    * Slight import performance speed improvements
* **2/24/2016 - Version 1.8.1:**
    * Add validation when entering monitoring locations
    * Add ability to set default Sample Fraction when importing using cross-tab templates
    * Add ability when importing cross-tab to handle empty columns
* **12/23/2015 - Version 1.8:**
    * New Feature: Import Translations: now before importing data you can define a mapping of your data to EPA acceptable data. This is helpful in cases where you receive data from labs using codes different from EPA and don't want to have to update the import spreadsheet every time.
* **6/5/2015 - Version 1.7:**
    * Sample result import validation enhancement: sample fraction required for certain characteristics 
    * Better error message when creating new user and email server not configured properly
    * Admin --&gt; Data Synch --&gt; updated to new URL for pulling Org list from EPA 
    * Bug fix: Fix collation error in create database script for REF_DATA table. 
    * Fix display issues when using Internet Explorer Version 7 or Compatibility View 
    * Fix monitoring location edit page to pull counties drop-down from county reference table
    * Better error handling when importing crosstab and monitoring location is missing
    * Updated Installation/Users Guide
    * 1.7.1 update:
        * Fix bug on Activity Edit page 
        * Add warning for users if they attempt to enter data before making the initial pull of reference data from EPA
    * 1.7.2 update 
        * New data filter added to Activity Search Page: WQX Submit status
        * When submitting to EPA and a record fails, error report now displays in human-readable format instead of XML report
        * Additional data validation on import samples
        * Bug fix: WQX submission history page not displaying when accessed via Activity page
        * Bug fix: handle situation where ResultStatus or ValueType is empty string when submitting to EPA
* **5/4/2015 - Version 1.6.2:** 
    * Improvements to Crosstab Import Template Configuration Page: characteristic, unit, and activity ID drop-downs added
    * Added new help page 
    * Updated Installation/Users Guide 
    * Fix import from cross tab when no Activity Type or Activity Media provided to show correct error message.
    * Cross-tab Activity Data Import Enhancement: new option to include seconds when autogenerating activity ID
    * Activity Data Import Enhancements: when detecting column data based on header text: (A) now case-insensitive (B) system can now detect column header alias names for certain columns
    * Activity Data Import Enhancements: when importing data that already has matching activity ID's added option to either replace or append to existing data
    * WQX History page expanded: now can also display records pending for WQX transfer and now available for non-global admins
    * Charting Page Improvements: added ability to filter only data shared with EPA; fix monitoring location drop-down
    * Public map improvement: added organization to popup window; add organization data filter 
    * Activity Details Page: added ability to view/edit more result fields (Laboratory, Lab Sample Prep Method, Prep Date, Dilution Factor)
* **4/3/2015 - Version 1.6:**  
    * MAJOR ENHANCEMENTS:  
    * New 'Getting Started Wizard' guides users through the initial startup steps (creating an organization, getting your organization provisioned, configuring default data values, importing data). 
    * New Data Import from EPA-WQX feature: You can now import monitoring locations, projects, and activities directly from EPA-WQX. This is helpful when getting started with Open Waters in situations where you already have data at EPA-WQX.
    * Greatly expanded Activity Import from Excel: now supports the import of most 100+ activity/result fields for chemical and biological monitoring
    * Greatly expanded Activity/Result Edit page: 20+ new fields added (sample collection method, analytic method, sample collection equipment, activity depth, biological monitoring fields, result status, sample fractions, lab analysis date, time zone, etc.) 
    * Deleted data synchronization: deleted records are now synchronized with EPA-WQX 
    * Self-Registration option: Added option (which can be turned off) that allows users to self-register their Open Waters accounts
    * Improved Organization-level Security: Users can now make a request to join an organization. Organization or global admins are notified on the dashboard when a request is made, where they can approve/deny access. 
    * Activity Search page improvements: display Monitoring Location, Project, and Samp Collection Method; add paging; remember search criteria; drop-downs now limited to your selected Org 
    * Reference Data Enhancements - 10 additional reference lists now synched with EPA (Method Speciation, Thermal Preservative Used, Cell Form, Cell Shape, Bio Assemblage, Bio Intent, Habit, Voltinism, and Statistical Base Code, Frequency Class Descriptor)
    * 4 organization-specific reference lists added (Laboratory, Analysis Method, Sample Collection Method, and Sample Prep Method) 
    * Reference data search feature added 
    * New Organization Default Data screen added: allows orgs to define the characteristics, taxa, units, detect limits, analytical methods, and time zone used by their organization, which speeds up subsequent data entry. 
    * MINOR ENHANCEMENTS:  
    * Cloud-based emailing: server admins now have the option to send emails using www.sendgrid.com (3rd party cloud-based emailing provider) if you don't have your own SMTP  
    * Beta invite option: added option to allow system administrator to require beta invites codes in order to register an account. 
    * Improved timezone handling: new Organization default value and automatic determination of daylight savings based on actvitiy date
    * Improve performance of WQX data submittals (only download from EPA when submit fails)
    * Mon Loc Import from Spreadsheet Enhancement: now supports option to import county/state/country by either code or name
    * Cleaned up storage of application settings. 
    * Fixed error in handling of county codes
    * Added ability for global admin to import reference data for a single table instead of all tables
    * Update .NET Framework from 4 to 4.5 
    * Fix units in dropdown not in alphabetical order
* **12/14/2014 - Version 1.5:**
    * New feature: batch import for monitoring locations and samples 
    * Example Excel templates for monitoring location, sample, and bio metrics added 
    * Added analytical methods to EPA data import 
    * Many bug fixes and usability improvements 
* **11/27/2014 - Version 1.4**
    * Supports organization-specific Exchange Network submission credentials
* **1/9/2014 - Version 1.3**
    * Better support for using multiple organizations such as Organization-specific application security, Organization-specific reference data
    * Added ability to define a subset of commonly-used characteristics (to speed up activity data entry) 
    * Added option to delete or inactivate monitoring locations   
* **8/20/2013 - Version 1.2**
    * New Mapping Page: view a map that displays your monitoring locations and most recent monitoring results. Includes both a private map (only available to your staff) and public map
