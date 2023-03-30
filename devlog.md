**March 24, 2023: Version 2 Development Launch	**

(Start) As of today, the coding has progressed to the point described in the DFD 0_Dissertation\Code\ChronAm\230317_ChronAm_DFD.pdf with the line ‘current progress’.
Recent efforts have included implementing a more logical directory system for code, data, and research as well as some (conceptual) provisions for backing everything up once we’re fully underway again. I’m also experimenting with various git options to provide better version control (at least for code).
The immediate objective in Version 2 is to reimplement and run existing code so it conforms better with good data and open research practices. To begin, I’m starting with the keyword list. Since it comes from a bit of prior knowledge with previous runs, there’s a bit of handwaving even if the words themselves can be traced back to particular sources in the “KW Scratch work” spreadsheet.
The original KW work is all saved in the in-directory archive. Of that material, the old code and KW work sheet will be copied into the v2 directory as starting points.

**March 27, 2023: keyword hit counte**r	
Most of the day’s work has been around reimplementing the code for checking the number of keyword hits per year. That’s been up and running. Previous approaches to this used a sheet specifying both keywords and particular search years. In order to eliminate the operator step, this code just cycles through all the years from 1777 to 1963. The idea is to take the code hit counts and (perhaps) use them to generate keyword hits. 
Also a little bit of housecleaning and adding new KO kw.

**March 29, 2023: LOC Title Pull**
Hit counter seems to work. NOTE: Need to add column headings to file to make it work in LOC hit counter.  Found a version of code for pulling titles that works. Making a few mods. Assigning the kw file as a var in the beginning (rather than hardcoding). Amended execution loop to skip any pings where no hits are found. But this still a bit buggy. I need to think about dynamic file naming.

OK. Clock is running down, but here’s the general idea. If we do one file for each combination, we’ll end up with a million combinations. But we want to rename dynamically so it’s easy to add new data when we run new keywords. We start off by initializing the file. 

**March 30, 2023: LOC Title Pull**
I have a tentative directory/file structure in mind for this part, but want to fix the gitignore file so its not getting so very clogged up. Sent the 23Mar22 DFD to Abby. 


