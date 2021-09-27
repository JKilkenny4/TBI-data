# TBI-data
This was a project I originally completed a few years ago while in grad school, but I've recently dusted it off to see if I can clean up / optimize some of the code. The goal of the project was to examine how, if at all, alcohol affects the severity of traumatic brain injuries and whether there is an interaction between alcohol and the type of inury sustained. All analyses for this project were performed in R.

First, it's important to get a couple of terms out of the way since they show up a number of times in the script/markdown:
* TBI = traumatic brain injury
* ETOH = a term taken from the abbreviation of "ethyl alcohol"; it's essentially the same thing as blood alcohol content (BAC) except that the scale is slightly different (i.e. ETOH = 80 is the same thing as BAC = .08)
* GCS = Glasgow Coma Scale; the GCS is a measure of normative functioning. You can find plenty of information on it with a quick Google because it's widly used in emergency rooms and trauma centers to evaluate how impaired someone is immediately following a head injury. The scale ranges from 3 to 15, with 15 indicating normal healthy functioning and 3 indicating complete incapacitation / death. 
* Type of injury = the data (more on that below) has a variable that indicates whether the injury was a blunt head injury (hit _on_ the head) or a penetrating head injury (hit _through_ the head)

A quick note on the data is warranted as well since you might notice that I did not provide data to accompany the code. This  was sourced from a statewide trauma database / outcomes project containing every TBI admitted to an ER / trauma center between 198X and 201X. It's not my right to share this data since it's not publicly available, and it may contain some PII, so I will not be sharing it in the interest of privacy / security. That being said, if there are any general questions, just shoot me a message and I'll be more than happy to answer them. 

With all of the table setting out of the way, on to the analyses!

In an effort to control for any potential influence demographics may play, I took a matched-samples approach, and used the match.it package to create two samples based on the type of injury sustained -- one sample of blunt head injuries, one sample of penetrating head injuries. In both samples, the demographics were similar and contained an equal proportion of sober v. intoxicated cases.

After creating the matched-samples, I conducted a 2X2 ANOVA examining whether GCS scores differed between these four groups. While there was not a significant interaction effect, there was a significant difference in GSC scores based on injury type, indicating that pentrating head injuries are more severe than blunt head injuries. 
