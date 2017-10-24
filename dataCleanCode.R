library(dplyr)
library(tidyr)
library(scales)
library(ggrepel)
library(forcats)

#cleaning scrape data!
stockx= read.csv("stockxScrapedData.csv", header = TRUE, stringsAsFactors = FALSE)
names(stockx) = c("sellDate", "resellPrice", "name", "size")
stockx = stockx[c(3,4,2,1)]
peyote950 = read.csv("peyote950.csv", header = TRUE)
names(peyote950) = c("name", "size", "sellDate", "resellPrice")
peyote950= peyote950[c(1,2,4,3)]
combatSand=read.csv("Season4CombatSand.csv", header=TRUE)
names(combatSand) = c("name", "resellPrice","sellDate","size")
combatSand= combatSand =combatSand[c(1,4,2,3)]

stockx= rbind(stockx, peyote950, combatSand)
stockx = stockx %>% filter(name != "" & resellPrice != "" & sellDate != "" & size != "")
stockx$resellPrice = gsub(",", "", stockx$resellPrice)
stockx$resellPrice = gsub("\\$", "", stockx$resellPrice)
stockx$resellPrice = as.numeric(stockx$resellPrice)
stockx$sellDate2= stockx$sellDate
stockx$sellDate =  as.Date(stockx$sellDate, format = "%A, %B %d, %Y")
stockx= stockx %>% separate(sellDate2, into=c("day", "date"), sep="y,")
stockx$day = paste0(stockx$day,"y")
stockx= select(stockx,-date)
stockx$day = factor(stockx$day, levels=c("Monday", "Tuesday", "Wednesday", "Thursday","Friday", "Saturday", "Sunday"))
stockx$sellMonth= format(stockx$sellDate, "%b %Y")

#saved cleaned stockx dataframe as csv!
write.csv(stockx,"stockx.csv")

# matching variables to each unique style of shoe(name), and will fill in my main dataframe.
model = rep(0, length(unique(stockx$name)))
color=rep(0, length(unique(stockx$name)))
retailPrice =rep(0, length(unique(stockx$name)))
releaseDate=rep(0, length(unique(stockx$name)))

shoeinfodf = data.frame(name= unique(stockx$name), model, color, retailPrice, releaseDate)
shoeinfodf[1,2:5]= c("350 V2", "multicolor", 220, "2017-02-25")
shoeinfodf[2,2:5]= c("350 V2", "white", 220, "2017-04-29")
shoeinfodf[3,2:5]= c("Powerphase", "white", 120, "2017-03-28")
shoeinfodf[4,2:5]= c("350 V2", "black", 220, "2017-02-11")
shoeinfodf[5,2:5]= c("350 V2", "gray", 220, "2016-09-24")
shoeinfodf[6,2:5]= c("350 V2", "black", 220, "2016-12-17")
shoeinfodf[7,2:5]= c("350 V2", "black", 220, "2016-11-23")
shoeinfodf[8,2:5]= c("750", "brown", 350, "2016-10-15")
shoeinfodf[9,2:5]= c("350 V2", "black", 220, "2016-11-23")
shoeinfodf[10,2:5]= c("350 V1", "black", 200, "2016-02-19")
shoeinfodf[11,2:5]= c("350 V2", "black", 220, "2016-11-23")
shoeinfodf[12,2:5]= c("750", "gray", 350, "2016-06-11")
shoeinfodf[13,2:5]= c("350 V1", "gray", 200, "2015-11-14")
shoeinfodf[14,2:5]= c("350 V1", "tan", 200, "2015-12-29")
shoeinfodf[15,2:5]= c("350 V1", "black", 200, "2015-08-22")
shoeinfodf[16,2:5]= c("750", "black", 350, "2015-12-19")
shoeinfodf[17,2:5]= c("350 V1", "multicolor", 200, "2015-06-27")
shoeinfodf[18,2:5]= c("750", "gray", 350, "2015-02-14")
shoeinfodf[19,2:5]= c("Season 4 Combat Boot", "brown", 445, "2017-04-24")
shoeinfodf[20,2:5]= c("Military Boot", "tan", 645, "2016-11-04")
shoeinfodf[21,2:5]= c("950 Boot", "black", 585, "2015-10-29")
shoeinfodf[22,2:5]= c("Crepe Boot", "tan", 645, "2016-06-06")
shoeinfodf[23,2:5]= c("950 Boot", "gray", 585, "2015-10-29")
shoeinfodf[24,2:5]= c("950 Boot", "brown", 585, "2015-10-29")
shoeinfodf[25,2:5]= c("Crepe Boot", "brown", 645, "2017-04-24")
shoeinfodf[26,2:5]= c("Military Boot", "orange", 645, "2016-11-04")
shoeinfodf[27,2:5]= c("Military Boot", "brown", 645, "2016-11-04")
shoeinfodf[28,2:5]= c("Crepe Boot", "tan", 645, "2017-04-24")
shoeinfodf[29,2:5]= c("Military Boot", "brown", 645, "2016-10-29")
shoeinfodf[30,2:5]= c("Crepe Boot", "brown", 645, "2016-08-01")
shoeinfodf[31,2:5]= c("950 Boot", "white", 585, "2015-10-29")
shoeinfodf[32,2:5]= c("Season 4 Combat Boot", "tan", 445, "2017-04-24")


write.csv(shoeinfodf,"shoeinfodf.csv")

stockxjoin = inner_join(stockx, shoeinfodf, by="name")

stockxjoin$releaseDate =as.character(stockxjoin$releaseDate)
stockxjoin$releaseDate =  as.Date(stockxjoin$releaseDate, format ="%Y-%m-%d")
stockxjoin$releaseMonth =  format(stockxjoin$releaseDate, "%b %Y")
stockxjoin$resellPrice = as.numeric(stockxjoin$resellPrice)
stockxjoin$retailPrice = as.numeric(stockxjoin$retailPrice)
stockxjoin= stockxjoin %>% mutate(resellPercentage = as.numeric((resellPrice- retailPrice)/retailPrice))
write.csv(stockxjoin, "stockxjoin.csv")

grouped_individual = stockxjoin %>% group_by(name)

grouped_model = stockxjoin %>% group_by(model)

grouped_color  = stockxjoin %>% group_by(colorway)

grouped_size = stockxjoin %>% group_by(size) %>% summarise(totals = n(), avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage))

grouped_size_model = stockxjoin %>% group_by(size, model)

EDA_by_model= grouped_model %>% summarise( avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage), firstRelease = min(releaseDate), highestPrice=max(resellPrice), count= n())

EDA_total= stockxjoin %>% summarise( avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage), firstRelease = min(releaseDate), highestPrice=max(resellPrice), count= n())

###############EDA############################
highestResell = arrange(stockxjoin, desc(resellPercentage))

filter(stockxjoin, resellPrice== max(resellPrice))
                     
unique(stockxjoin$model)      

EDA_total= stockxjoin %>% summarise( avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage), firstRelease = min(releaseDate), highestPrice=max(resellPrice), count= n())
check = grouped_model %>% summarise(retailTotal = sum(retailPrice), resellTotal = sum(resellPrice)) %>% mutate (resellAvg= (resellTotal-retailTotal)/retailTotal)

grouped_model %>% summarise(styles= n_distinct(name))

#####TOTALS#####
totalSales= read.csv("totalSales.csv", header= TRUE, stringsAsFactors = FALSE)
totalSalesJoin = inner_join(totalSales, shoeinfodf, by="name") 
totalSalesJoin =  totalSalesJoin %>% arrange(desc(totals))
totalSales_grouped = totalSalesJoin %>% group_by(model) %>% summarise(totals2= as.numeric(sum(totals))) 
other=c("Other", 163)
totalSales_grouped = rbind(totalSales_grouped, other) 
totalSales_grouped = totalSales_grouped %>% filter(model %in% c("Other","750","350 V1","Powerphase", "350 V2"))
totalSales_grouped$model =as.factor(totalSales_grouped$model)
totalSales_grouped$model = factor(totalSales_grouped$model, levels=c("350 V2", "Powerphase", "350 V1", "750", "Other"))



top10units= top_n(totalSalesJoin, 10, totals)
top10resellPercent =  stockxjoin %>% group_by(name) %>% summarise(avgResellPercentage= mean(resellPercentage)) %>% arrange(desc(avgResellPercentage))
top10resellPercent = top_n(top10resellPercent,10, avgResellPercentage)


#########GRAPHS################
#EDA- bar chart by model and selling penetration- pie chart by percentage!
percentSales = as.numeric(totalSales_grouped$totals2)/sum(as.numeric(totalSales_grouped$totals2))
#(bar chart version instead of pie chart) g= ggplot(data= totalSales_grouped, aes(x= "", y = percentSales, fill= model)) + geom_bar(stat="identity", width=1) + coord_polar("y", start=0)
g= ggplot(data= totalSales_grouped, aes(x= "", y = percentSales, fill= model)) + 
  geom_bar(stat="identity", width=1) + 
  coord_polar("y", start=0) +
  geom_label_repel(aes(label = paste0(as.character(round(percentSales*100, digits=1)), "%")), size=5, show.legend = F, nudge_x = 1) +
  guides(fill = guide_legend(title = "model"))
g

#EDA- Top 10 selling style- units sold
g2= ggplot(data= top10units, aes(x= reorder(name,-as.numeric(totals)), y = as.numeric(totals))) + geom_bar(stat="identity", aes(fill=name))
g2

#EDA- Top 10 selling style- resellPercentage
g3= ggplot(data= top10resellPercent, aes(x= reorder(name,-as.numeric(avgResellPercentage)), y = as.numeric(avgResellPercentage))) + geom_bar(stat="identity", aes(fill=name))
g3



#BREAKOUT OF SIZE!
grouped_size = stockxjoin %>% group_by(size) %>% summarise(totals = n(), avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage))
grouped_size$size = as.factor(grouped_size$size)
prac= grouped_size %>% summarise(totals=sum(totals))


#all yeezy's by size vs units sold
g4= ggplot(data= grouped_size, aes(x= size, y = totals/sum(totals))) + geom_bar(stat="identity", aes(fill=size))
g4
# all yeezy's by size vs resell price
g5= ggplot(data= grouped_size, aes(x= size, y = avgResellPrice)) + geom_bar(stat="identity", aes(fill=size))
g5
# all yeezy's by size vs resell percentage
g6= ggplot(data= grouped_size, aes(x= size, y = avgResellPercent)) + geom_bar(stat="identity", aes(fill=size))
g6

###grouping by size and model!
grouped_size_model = stockxjoin %>% filter(resellPrice!="5109")%>% group_by(size, model) %>% filter(model %in% c("350 V1","350 V2", "750", "Powerphase")) %>% summarise(totals = n(), avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage))
grouped_size_model$size = as.factor(grouped_size_model$size)
#model- size vs units sold 
g7= ggplot(data= grouped_size_model, aes(x= size, y = totals/sum(totals))) + geom_bar(stat="identity", aes(fill=size))+ facet_grid(model~.)
g7
#model- size vs resell price 
g8= ggplot(data= grouped_size_model, aes(x= size, y = avgResellPrice)) + geom_bar(stat="identity", aes(fill=size))+ facet_grid(model~.)
g8

#model- size vs resell percentage 
g9= ggplot(data= grouped_size_model, aes(x= size, y = avgResellPercent)) + geom_bar(stat="identity", aes(fill=size))+ facet_grid(model~.)
g9

#######BY DAY#######
grouped_day = stockxjoin %>%  group_by(day) %>% filter(model %in% c("350 V1","350 V2", "750", "Powerphase")) %>% summarise(totals = n(), avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage))

#model- size vs units sold 
g10= ggplot(data= grouped_day, aes(x= day, y = totals/sum(totals))) + geom_bar(stat="identity", aes(fill=day))
g10
#model- size vs resell price 
g11= ggplot(data= grouped_day, aes(x= day, y = avgResellPrice)) + geom_bar(stat="identity", aes(fill=day))
g11

#model- size vs resell percentage 
g12= ggplot(data= grouped_day, aes(x= day, y = avgResellPercent)) + geom_bar(stat="identity", aes(fill=day))
g12

#######BY COLOR#######
grouped_color = stockxjoin %>%  group_by(color) %>% filter(model %in% c("350 V1","350 V2", "750", "Powerphase")) %>% summarise(totals = n(), avgResellPrice = mean(resellPrice), avgResellPercent = mean(resellPercentage))

#model- size vs units sold 
g13= ggplot(data= grouped_color, aes(x= color, y = totals/sum(totals))) + geom_bar(stat="identity", aes(fill=color))
g13
#model- size vs resell price 
g14= ggplot(data= grouped_color, aes(x= color, y = avgResellPrice)) + geom_bar(stat="identity", aes(fill=color))
g14

#model- size vs resell percentage 
g15= ggplot(data= grouped_color, aes(x= color, y = avgResellPercent)) + geom_bar(stat="identity", aes(fill=color))
g15


#G6 G9 G12 G15 not really necessary as avg resellPercent and avg resellPrice are slightly repetitive

######TIME??
totalYeezy = stockxjoin %>% group_by(sellMonth) %>% summarise(avg =mean(resellPrice))
totalYeezy$sellMonth =  tolower(totalYeezy$sellMonth)
totalYeezy$sellMonth = factor(totalYeezy$sellMonth, 
                              levels = c("mar 2015", "apr 2015", "may 2015", "jun 2015", "jul 2015", "aug 2015", "sep 2015", "oct 2015", "nov 2015", "dec 2015", 
                                         "jan 2016", "feb 2016", "mar 2016", "apr 2016", "may 2016", "jun 2016", "jul 2016", "aug 2016", "sep 2016", "oct 2016", "nov 2016", "dec 2016", 
                                         "jan 2017", "feb 2017", "mar 2017", "apr 2017", "may 2017", "jun 2017", "jul 2017", "aug 2017", "sep 2017", "oct 2017", "nov 2017", "dec 2017"
                                        ))



#all yeezys over month of selling
g16= ggplot(data=totalYeezy, aes(x=sellMonth, y=avg, group =1)) +
  geom_line() + geom_point()
g16

#track top 10 models(by resell percentage)
top10resellPercentbyMonth =  stockxjoin %>% filter((name != "adidas Yeezy Boost 750 Triple Black" | sellMonth != "Sep 2016" )) %>% group_by(name, sellMonth) %>% summarise(avgResellPercentage= mean(resellPercentage)) %>% arrange(desc(avgResellPercentage))
top10resellPercentbyMonth = top10resellPercentbyMonth %>% filter(name %in% top10resellPercent$name) %>% arrange(desc(avgResellPercentage))
top10resellPercentbyMonth$sellMonth = tolower(top10resellPercentbyMonth$sellMonth)
top10resellPercentbyMonth$sellMonth = factor(top10resellPercentbyMonth$sellMonth, 
                                             levels = c("mar 2015", "apr 2015", "may 2015", "jun 2015", "jul 2015", "aug 2015", "sep 2015", "oct 2015", "nov 2015", "dec 2015", 
                                                        "jan 2016", "feb 2016", "mar 2016", "apr 2016", "may 2016", "jun 2016", "jul 2016", "aug 2016", "sep 2016", "oct 2016", "nov 2016", "dec 2016", 
                                                        "jan 2017", "feb 2017", "mar 2017", "apr 2017", "may 2017", "jun 2017", "jul 2017", "aug 2017", "sep 2017", "oct 2017", "nov 2017", "dec 2017"
                                             ))


#all together one one map
g17= ggplot(data=top10resellPercentbyMonth, aes(x=sellMonth, y=avgResellPercentage, group = name, color = name)) +
  geom_line() + geom_point()

g17

#facet_wrap
g18= ggplot(data=top10resellPercentbyMonth, aes(x=sellMonth, y=avgResellPercentage, group = name, color = name)) +
  geom_line() + geom_point() + facet_wrap(~name)
g18

##########resellPercentage by model 
top10resellPercentbyModel =  stockxjoin %>% group_by(model, sellMonth) %>% summarise(avgResellPercentage= mean(resellPercentage)) %>% filter(model %in% c("350 V1","350 V2", "750", "Powerphase")) %>% arrange(desc(avgResellPercentage))
top10resellPercentbyModel$sellMonth = tolower(top10resellPercentbyModel$sellMonth)
top10resellPercentbyModel$sellMonth = factor(top10resellPercentbyModel$sellMonth, 
                                             levels = c("mar 2015", "apr 2015", "may 2015", "jun 2015", "jul 2015", "aug 2015", "sep 2015", "oct 2015", "nov 2015", "dec 2015", 
                                                        "jan 2016", "feb 2016", "mar 2016", "apr 2016", "may 2016", "jun 2016", "jul 2016", "aug 2016", "sep 2016", "oct 2016", "nov 2016", "dec 2016", 
                                                        "jan 2017", "feb 2017", "mar 2017", "apr 2017", "may 2017", "jun 2017", "jul 2017", "aug 2017", "sep 2017", "oct 2017", "nov 2017", "dec 2017"
                                             ))


#all together one one map
g19= ggplot(data=top10resellPercentbyModel, aes(x=sellMonth, y=avgResellPercentage, group = model, color = model)) +
  geom_line() + geom_point()
g19

#don't need facet_wrap for models, only 4 variables
#g20= ggplot(data=top10resellPercentbyModel, aes(x=sellMonth, y=avgResellPercentage, group = 1, color = model)) +
  #geom_line() + geom_point() + facet_wrap(~model)
#g20

#COLOR OVER TIME NO IMPORTANT INFO SO PROBABLY WON'T INCLUDE
##########resellPercentage by color
#top10resellPercentbyColor =  stockxjoin %>% group_by(color, sellMonth) %>% summarise(avgResellPercentage= mean(resellPercentage)) %>% arrange(desc(avgResellPercentage))
#top10resellPercentbyColor$sellMonth = tolower(top10resellPercentbyColor$sellMonth)
#top10resellPercentbyColor$sellMonth = factor(top10resellPercentbyColor$sellMonth, 
#                                             levels = c("mar 2015", "apr 2015", "may 2015", "jun 2015", "jul 2015", "aug 2015", "sep 2015", "oct 2015", "nov 2015", "dec 2015", 
#                                                        "jan 2016", "feb 2016", "mar 2016", "apr 2016", "may 2016", "jun 2016", "jul 2016", "aug 2016", "sep 2016", "oct 2016", "nov 2016", "dec 2016", 
#                                                        "jan 2017", "feb 2017", "mar 2017", "apr 2017", "may 2017", "jun 2017", "jul 2017", "aug 2017", "sep 2017", "oct 2017", "nov 2017", "dec 2017"
#                                             ))


#all together one one map
#g21= ggplot(data=top10resellPercentbyColor, aes(x=sellMonth, y=avgResellPercentage, group = color, color = color)) +
  #geom_line() + geom_point()
#g21
#g22= ggplot(data=top10resellPercentbyColor, aes(x=sellMonth, y=avgResellPercentage, group = color, color = color)) +
  #geom_line() + geom_point() + facet_wrap(~color)
#g22


#############units sold by model over time not as useful due to cutoff of data
#top10UnitsSoldbyStyle =  stockxjoin %>% group_by(name, sellMonth) %>% summarise(totals= n()) %>% arrange(desc(totals))
#top10UnitsSoldbyStyle = top10UnitsSoldbyStyle %>% filter(name %in% top10units$name) %>% arrange(desc(totals))
#top10UnitsSoldbyStyle$sellMonth = tolower(top10UnitsSoldbyStyle$sellMonth)
#top10UnitsSoldbyStyle$sellMonth = factor(top10UnitsSoldbyStyle$sellMonth, 
#                                             levels = c("mar 2015", "apr 2015", "may 2015", "jun 2015", "jul 2015", "aug 2015", "sep 2015", "oct 2015", "nov 2015", "dec 2015", 
#                                                        "jan 2016", "feb 2016", "mar 2016", "apr 2016", "may 2016", "jun 2016", "jul 2016", "aug 2016", "sep 2016", "oct 2016", "nov 2016", "dec 2016", 
#                                                        "jan 2017", "feb 2017", "mar 2017", "apr 2017", "may 2017", "jun 2017", "jul 2017", "aug 2017", "sep 2017", "oct 2017", "nov 2017", "dec 2017"
#                                             ))
#

#all together one one map
#g23= ggplot(data=top10UnitsSoldbyStyle, aes(x=sellMonth, y=totals, group = name, color = name)) +
#  geom_line() + geom_point()
#g23

#facet_wrap
#g24= ggplot(data=top10UnitsSoldbyStyle, aes(x=sellMonth, y=totals, group = 1, color = name)) +
#  geom_line() + geom_point() + facet_wrap(~name)
#g24




#more box plots?
#not as important
size, color, model, styles

resellPrice

#box plot by model
g25= ggplot(data= stockxjoin %>% filter(model %in% c("750","350 V1","Powerphase", "350 V2")), aes(x=reorder(model, -resellPrice, FUN =median), y= resellPrice)) + geom_boxplot()
g25

#boxplot by color
g26= ggplot(data= stockxjoin, aes(x=reorder(color,-resellPrice, FUN=median), y= resellPrice)) + geom_boxplot()
g26

#box plot by size
g27= ggplot(data= stockxjoin, aes(x=reorder(as.factor(size), -resellPrice, FUN=median), y= resellPrice)) + geom_boxplot()
g27

#boxplot by top10 styles
g28= ggplot(data= stockxjoin %>% filter(name %in% top10resellPercent$name), aes(x=reorder(name, -resellPrice, FUN =median), y= resellPrice)) + geom_boxplot()
g28



#individual styles change over time for all 31 styles if I do shiny!
#yeezy price generator
#time line graphs can do resll price and units sold! if I do shiny app.






