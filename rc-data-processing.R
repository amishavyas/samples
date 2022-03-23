##--------------------------------------
## Reverse correlation Task: Data Processing 

## RC Task provides us with visual prototypes of morally good and warm faces.
## This script conducts some data processing to make it suitable for Classification Image Generation
## Specifically, we remove subjects who fail more than 25% of the attention checks
## and manipulate the response column from {1,2} to conditional {1, -1}

## By Amisha. March 3, 2022.  

##---------------------------------------


library(dplyr)
library(plyr)

path = "/Users/amisha/Desktop/revcorr-data-final/processed_data/*"

#combine individual data files into a single large data file 
processed_files = Sys.glob(path)
data = bind_rows(lapply(processed_files, read.csv)) 

#select trial rows that include attention checks only
attn_data = data %>% filter(grepl('.jpg', picture1))

#new column 'correct_resp' indicates the correct response for the attn check
attn_data$correct_resp <- ifelse(attn_data$picture1 == 'click.jpg', 1, 2)

#new column 'correct_check' indicates T/F for each attn check 
attn_data$correct_check <- ifelse(attn_data$numSelected == attn_data$correct_resp, TRUE, FALSE)

#to get proportion of attn checks correctly completed 
checks_data = aggregate(attn_data$correct_check, by=list(subjid=attn_data$subjid), FUN=sum)
checks_data$count = aggregate(attn_data$correct_check, by=list(subjid=attn_data$subjid), FUN=length)[2]

#gives errors if cols are not renamed 
colnames(checks_data) <- c('subjid','sum','count') 

checks_data <- transform(checks_data, prop =  sum / count) 
hist(checks_data$x) 

bad_subs = checks_data[checks_data$x < 0.75, ] 

#remove bad subjects 
final_data <- data[ ! data$subjid %in% c(bad_subs$subjid), ]

#select trials of good subs without attention checks 
CI_data = final_data %>% filter(grepl('.png', picture1))


# response should be changed to 1 if 'ori' image was selected.
# response should be changed to -1 if 'inv' image was selected 
# + string manipulation to get stim # 
# necessary to create classification images 

final_CI_data = CI_data %>% mutate(response =
                     case_when(numSelected == 1 & grepl('ori.png', picture1)  ~ "1", 
                               numSelected == 2 & grepl('ori.png', picture2)  ~ "1",
                               numSelected == 1 & grepl('inv.png', picture1)  ~ "-1",
                               numSelected == 2 & grepl('inv.png', picture2)  ~ "-1"),
                     stimulus = 
                     case_when(substr(picture1, 15, 15) == 0 ~ substr(picture1, 16, 17), 
                               substr(picture1, 15, 15) != 0 ~ substr(picture1, 15, 17))
)

write.csv(final_CI_data,'/Users/amisha/Desktop/thesis/final_CI_data.csv')

#moral / warm CI data csv 
moral_CI_data = final_CI_data %>% filter(grepl('moral', condition))
warm_CI_data = final_CI_data %>% filter(grepl('warm', condition))

write.csv(moral_CI_data,'/Users/amisha/Desktop/thesis/warm_CI_data.csv')
write.csv(warm_CI_data,'/Users/amisha/Desktop/thesis/moral_CI_data.csv')
