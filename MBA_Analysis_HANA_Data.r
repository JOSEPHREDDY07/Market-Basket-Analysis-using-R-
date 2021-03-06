library('RODBC')
library(arules)
library("arulesViz")
library(Matrix)
library(xlsx)
library("plotrix")
library("RColorBrewer")

ch<-odbcConnect("HY1",uid="REDDY",pwd="password");

res <-sqlQuery(ch, 'SELECT INVOICE, PRODUCT, ORDERS,SALESVALUE FROM SCHEMA.CBC_MBA')
summary(res)

list(res)
res$INVOICE <- discretize(res$INVOICE)
res$ORDERS <- discretize(res$ORDERS) 
res$SALESVALUE <- discretize(res$SALESVALUE) 


rules <- apriori(res, parameter = list(supp = 0.001, conf = 0.6, minlen = 2))
rules <- sort(rules, by="lift", decreasing=TRUE)
inspect(rules)
summary(rules) 

#Scatter plot of rules:
plot(rules,control=list(col=brewer.pal(11,"Spectral")),main="")

inspect(head(sort(rules, by ="lift"),5))

#The most interesting rules reside on the support/confidence border which can be clearly seen in this plot.

#Plot graph-based visualisation:
subrules2 <- head(sort(rules, by="lift"), 30)

plot(subrules2, method="graph",control=list(type="items",main=""))

itemFrequencyPlot(res, topN = 25)
#res1 <- as.matrix(res)
#itemFrequencyPlot(res1,topN=20,type="absolute")
PRODUCT=res$PRODUCTNAME
NOOFORDERS=sum(res$ORDERS)
barplot(res$ORDERS,names.arg=res$PRODUCTNAME, main ="ORDERS PER PRODUCT")
barplot(sum(res$SALESVALUE),names.arg=res$PRODUCTNAME, main ="SALES VALUE PER PRODUCT")

PRODUCT=res$PRODUCTNAME
NOOFORDERS=sum(res$ORDERS)
barplot(res$ORDERS,names.arg=res$PRODUCTNAME, main ="ORDERS PER PRODUCT")
barplot(sum(res$SALESVALUE),names.arg=res$PRODUCTNAME, main ="SALES VALUE PER PRODUCT")

plot(x = res$ORDERS , y = res$PRODUCTNAME, type = 'p')

hist(res$ORDERS)

plot(res$ORDERS, type="o", col="blue")
# Create a title with a red, bold/italic font
title(main="ORDERS", col.main="red", font.main=4)

# Define 2 vectors
plot(res$ORDERS, type="o", col="blue", ylim=c(0,12))
# Graph SALES VALUE with red dashed line and square points
lines(res$SALESVALUE, type="o", pch=22, lty=2, col="red")

# Create a title with a red, bold/italic font
title(main="ORDERS AND VALUE", col.main="red", font.main=4)

# Create a pie chart with defined heading and
# custom colors and labels
pie(res$SALESVALUE, main="SALES VAL", col=rainbow(length(res$SALESVALUE)),labels=res$PRODUCTNAME)


odbcClose(ch)
