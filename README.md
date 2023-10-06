# VD Workbench
Vehicle Dynamics analysis scripts and functions for the Formula Buckeyes project team at Ohio State. 

## Getting Started
To download all of these files, use the `Code` button in the top right corner. 

- Once opened in MATLAB, the VDWorkbench.mlx file is the main place for data analysis. Feel free to tweak the Code and Display sections to fit your needs.
- Need another calculation? Work one out on the Workbench or create a new function (.m file) using the predefined variables from the Setup Section. 
## File Reference

#### Main Folder

| File | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `VDWorkbench.mlx` | `Live Script` | Main playground for analysis and testing new functions |
| `VDWorkbenchMultiRun.mlx` | `Live Script` | Like the original, but with a for loop for multiple file imports. Doesn't work well. |
| `SummaryEndurance.mlx` | `Live Script` | Outputs a few graphs and tables in an html page format to easily summarize an Endurance log. |
| `FB2223.m` | `Class` | Contains car measurements and methods to update them. |
| `.gitignore` | `gitignore` | Tells github not to upload anything it doesn't need to, like data or autosave files. |

#### Functions Folder

| File | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `motecImport.m` | `Function` | Main method of importing CSV files exported by Motec |
| `*.m` | `Function` | All custom functions should have descriptive titles and comments so others can use and interpret your code! |


#### Data Folder
This folder is optional, but if you want to store CSV files in the same place as the code that's accessing it, here's a place. 

#### html Folder
This is where Summary Sheet programs are set to export their files. 

## Contributing
Contributions are always welcome! Send Ethan a message on Slack to gain editing access, propose feature requests, or share code snippets.
