# Metabolic Power Monitoring
This repository contains an app and Matlab routines for
1. processing position and heart rate data, modelling energy via the Metabolic Power approach (Quelle) and calculate load parameters
2. download data from Polar Pro Team via API 
3. create a comprehensive monitoring report including references from previous sessions based on 1.
The code works currently fine for the Polar Team Pro system, manually and via API downloaded data. 
## The app
The desktop app can be easily installed via the web installer (.exe) in `MetPowMon\main\App\MPA\for_redistribution` which uses the Matlab R2020b Runtime environment. The latter will be installed as well. Unless you have already installed this or are a Matlab User try out the other folders in this directory or use the scripts directly without the app.
### create your profile
...
### save changes to your profile
- you can edit your profile (upper right) and the individual reference (lower right)
- make sure you hit 'Save Profile' to save the changes before closing the app or switching the profile
### download data (API)
- set up your client id and secret (see below)
- button 'Online Data' will be available if the right source is selected in the profile
- this button will open a new dialogue
- select your data and click 'download'
- data will be saved in `Datafolder`
### analyze data
- make sure you have set the path of your data directory in your profile (`Datafolder`)
- you can filter already analyzed data
- select the desired sessions and click `Analyze`
- data will be saved in `Rootfolder\DataBase`
### create a reference
- select sessions in the 'Analyzed Data' panel
- click 'Create Reference'
- enter a name
- the reference panel on the right will update
### create a report
- select sessions in the 'Analyzed Data' panel
- select 'TRAINING' or 'GAME'
- click 'Create Report'
- report will be saved in `Rootfolder\Report`
### export load table
- select sessions in the 'Analyzed Data' panel
- click 'Export Tables'
- A table will be saved in `Rootfolder\Export`
### set up a new template
...
## Data processing
The data are currently processed by each participant consecutively within each session. Pre-processing includes partitioning the data into parts according to the tracked phases in the session. Therefore, using manual downloaded data as a source requires the summary file for each session analyzed. The main calculations take place in `featureCalc.m`. The current output variables can be looked up by loading the struct `S` from `Settings.mat` and look up `S.VarNames` or in the previous script itself. The export is organized in a .mat file for each session containing a table for load parameters (e.g. Total distance, speed zones, energy, anaerobic index, etc.) and vectors (e.g. high-intensity actions, Metabolic Power, VO2). 
### Individualization
This procedure involves some specific information about the subjects, e.g. body weight for metabolic power. Therefore, a separate table for each profile containing information about individuals is saved in `S.Profile.Norm`. Individual thresholds can be used to calculate the anaerobic index (Quelle) or energy spent in individualized energy zones. TRIMP (heart rate load: `TRIMP = a*exp(b*dHR`) with dHR as the fractional heart rate reserve) parameters can be individualized by setting the coefficients `a` and `b` in the table.
## Reference
A reference can be created from analyzed sessions, which involves means and standard deviations for individuals and the team. This reference is used for comparison in the report.
## Report
The report creates a PDF file with summary tables and visualisations based on the session and a reference using Matlabs `mlreportgen.dom` package. Options `GAME` (requires several phases) and `TRAINING` (less detailed information) are selectable. There are sections for the team and each individual. The report can be based on each valid parameter in the load parameter table.
## API
Data can be automatically downloaded via the Polar Team Pro API. To use the API you have to follow the steps explained here: https://www.polar.com/teampro-api/#teampro-api Save your client id and client secret in `MetPowMon\main\client.mat` or the app. For first-time use, you will be asked to log in and insert an access token from the URL in your browser to a dialogue box. Afterwards, a refresh token will be saved to minimize the manual input. When downloading data, the response objects will be pre-processed to structs and tables and clustered into .mat-files for each session, containing sensor data for each participant.
## Use the Matlab scripts
The 4 steps of data processing, creating references, constructing reports and download data can be done by using the 4 scripts in `MetPowMon\main\Matlab`.
