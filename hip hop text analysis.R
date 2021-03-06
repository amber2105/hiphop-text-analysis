hiphop_data <- read.csv('hiphophistory-lyrics.csv', stringsAsFactors = FALSE, row.names = 1)
install.packages("readr", "stringr")
install.packages("quanteda")
library(quanteda)
library(readr)
library(stringr)
library(dplyr) #Data manipulation (also included in the tidyverse package)
library(tidytext) #Text mining
library(tidyr) #Spread, separate, unite, text mining (also included in the tidyverse package)


#Visualizations!
install.packages("ggplot2")
library(ggplot2) #Visualizations (also included in the tidyverse package)
library(ggrepel) #`geom_label_repel`
library(gridExtra) #`grid.arrange()` for multi-graphs
library(knitr) #Create nicely formatted output tables
library(kableExtra) #Create nicely formatted output tables
library(formattable) #For the color_tile function
library(circlize) #Visualizations - chord diagram
library(yarrr)  #Pirate plot
library(radarchart) #Visualizations
library(igraph) #ngram network diagrams
library(ggraph) #ngram network diagrams

#Add decades field
hiphop_data <- hiphop_data %>%
  mutate(decade = 
                  ifelse(hiphop_data$Year %in% 1980:1989, "1980s", 
                         ifelse(hiphop_data$Year %in% 1990:1999, "1990s", 
                                ifelse(hiphop_data$Year %in% 2000:2009, "2000s", 
                                       ifelse(hiphop_data$Year %in% 2010:2017, "2010s", 
                                              "NA")))))

hiphop_data <- hiphop_data %>%
  mutate(decade = 
           ifelse(hiphop_data$Year %in% 1980:1989, "1980s", 
                  ifelse(hiphop_data$Year %in% 1990:1999, "1990s", 
                         ifelse(hiphop_data$Year %in% 2000:2009, "2000s", 
                                ifelse(hiphop_data$Year %in% 2010:2017, "2010s", 
                                       "NA")))))


#Add region field
EC.abrv <- c("CT","ME","MA","NH","RI","VT","NJ","NY","PA", "MD", "DC")
MW.abrv <- c("IN","IL","MI","OH","WI","IA","KS","MN","MO","NE",
             "ND","SD")
S.abrv <- c("DE","FL","GA","NC","SC","VA","WV","AL",
            "KY","MS","TN","AR","LA","OK","TX")
W.abrv <- c("AZ","CO","ID","NM","MT","UT","NV","WY","AK","CA",
            "HI","OR","WA")

hiphop_data <- hiphop_data %>%
  mutate(Region = 
           ifelse(hiphop_data$State %in% EC.abrv, "East Coast", 
                  ifelse(hiphop_data$State %in% MW.abrv, "Midwest", 
                         ifelse(hiphop_data$State %in% S.abrv, "South", 
                                ifelse(hiphop_data$State %in% W.abrv, "West Coast", 
                                       "NA")))))


theme_lyrics <- function(aticks = element_blank(),
                         pgminor = element_blank(),
                         lt = element_blank(),
                         lp = "none",
                         family = "Helvetica")
{
  theme(plot.title = element_text(hjust = 0.5), #Center the title
        axis.ticks = aticks, #Set axis ticks to on or off
        panel.grid.minor = pgminor, #Turn the minor grid lines on or off
        legend.title = lt, #Turn the legend title on or off
        legend.position = lp) #Turn the legend on or off
}

#Define some colors to use throughout
my.color <- c("azure4", "chocolate2", "cornflowerblue", "firebrick3")
my_colors <- c("#E69F00", "#56B4E9", "#009E73", "#CC79A7", "#D55E00", "#D65E00")

glimpse(hiphop_data)

undesirable_words <- c("chorus", "repeat", "lyrics",
                       "yeah", "alright", "wanna", "gonna", "baby",
                       "alright", "verse", "hey", "yo", "verse", "gotta", "make", "hook", "niggas", "nigga",
                       "cube", "uh", "huh", "tootsee", "da", "duh", "soulja",
                       "yellow", "x6", "phantom", "na", "nah", "bow", "dat", "lil",
                       "crank", "respose", "50", "chris brown", "twistin", "humpty",
                       "doop", "hip", "hop", "rocka", "motion", "dogg", "ice", "ooh",
                       "i'ma", "hol", "shit", "fuck", "ass", "wow", "boom", "bitch",
                       "panda", "biggie", "heyyy", "dun", "o.p.p","huuh",
                       "poom", "funkdafied", "thurr", "luther", "phuncky",
                       "yuuuuuuu", "ayyy", "nae", "miya", "aiy", "miggida", "hump",
                       "doggy", "bada", "doo", "km.g", "paradise", "warren", "shoop",
                       "ayy", "gon", "flava", "nelly", "cent", "maaagic", "ludacris",
                       "drake", "smith", "anaconda", "b.o.b", "rexha", "gon", "efx",
                       "chris", "bitches", "iggy", "azalea", "swae", "gniht", "esrever",
                       "pilf", "nwod", "tup", "chainz", "heyy", "kanye", "fuckin", "y'all",
                       "kyle", "will.i.am", "candyman", "rowland", "mase", "hah", "ohh",
                       "sen", "ughhhhhh", "twista", "nate")
                    
                       
#Cleans up lyrics
tidy_lyrics <- hiphop_data %>%
  unnest_tokens(word, lyrics) %>% #Break the lyrics into individual words
  filter(!word %in% undesirable_words) %>% #Remove undesirables
  filter(!nchar(word) < 3) %>% #Words like "ah" or "oo" used in music
  anti_join(stop_words) #Data provided by the tidytext package

#Most used words in entire dataset
glimpse(tidy_lyrics) %>%
  filter(Region == "South")

tidy_lyrics %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(decade == "1990s") %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(decade == "2000s") %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(decade == "2010s") %>%
  count(word, sort = TRUE) 
  
tidy_lyrics %>%
  filter(Region == "East Coast") %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(Region == "West Coast") %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(Region == "South") %>%
  count(word, sort = TRUE) 

tidy_lyrics %>%
  filter(Region == "Midwest") %>%
  count(word, sort = TRUE) 


#Distinct words per decade
word_summary <- tidy_lyrics %>%
  group_by(decade, Song) %>%
  filter(!decade == "1980s") %>%
  mutate(word_count = n_distinct(word)) %>%
  select(Song, Released = decade, word_count) %>%
  distinct() %>% #To obtain one record per song
  ungroup()

install.packages("yarrr")
library(yarrr)
pirateplot(formula =  word_count ~ Released, #Formula
           data = word_summary, #Data frame
           xlab = NULL, ylab = "Song Distinct Word Count", #Axis labels
           main = "Lexical Diversity Per Decade", #Plot title
           pal = my.color, #Color scheme
           point.o = .2, #Points
           avg.line.o = 1, #Turn on the Average/Mean line
           theme = 0, #Theme
           point.pch = 16, #Point `pch` type
           point.cex = 1.5, #Point size
           jitter.val = .1, #Turn on jitter to see the songs better
           family = "Helvetica",
           cex.lab = .9, cex.names = .7) #Axis label size

#Distinct words per Year
word_summary_year <- tidy_lyrics %>%
  group_by(Year, Song) %>%
  mutate(word_count = n_distinct(word)) %>%
  select(Song, Released = Year, word_count) %>%
  distinct() %>% #To obtain one record per song
  ungroup()

pirateplot(formula =  word_count ~ Released, #Formula
           data = word_summary_year, #Data frame
           xlab = NULL, ylab = "Song Distinct Word Count", #Axis labels
           main = "Lexical Diversity Per Year", #Plot title
           pal = "google", #Color scheme
           family = "Helvetica",
           point.o = .2, #Points
           avg.line.o = 1, #Turn on the Average/Mean line
           theme = 0, #Theme
           point.pch = 16, #Point `pch` type
           point.cex = 1.5, #Point size
           jitter.val = .1, #Turn on jitter to see the songs better
           cex.lab = .9, cex.names = .7) #Axis label size

#Distinct words by region
word_summary <- tidy_lyrics %>%
  group_by(Region, Song) %>%
  filter(!Region == "NA") %>%
  mutate(word_count = n_distinct(word)) %>%
  select(Song, Region = Region, word_count) %>%
  distinct() %>% #To obtain one record per song
  ungroup()

pirateplot(formula =  word_count ~ Region, #Formula
           data = word_summary, #Data frame
           xlab = NULL, ylab = "Song Distinct Word Count", #Axis labels
           main = "Regional Lexical Diversity", #Plot title
           pal = my.color, #Color scheme
           point.o = .2, #Points
           avg.line.o = 1, #Turn on the Average/Mean line
           theme = 0, #Theme
           point.pch = 16, #Point `pch` type
           point.cex = 1.5, #Point size
           jitter.val = .1, #Turn on jitter to see the songs better
           cex.lab = .9, cex.names = .7) #Axis label size

#Rough sentiment analysis
nrc_joy <- get_sentiments("nrc") %>%
  filter(sentiment == "joy")

tidy_lyrics %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)

nrc_sadness <- get_sentiments("nrc") %>%
  filter(sentiment == "sadness")

tidy_lyrics %>%
  inner_join(nrc_sadness) %>%
  count(word, sort = TRUE)


tidy_lyrics %>%
  inner_join(get_sentiments("bing")) %>% # pull out only sentiment words
  count(sentiment) %>% # count the # of positive & negative words
  spread(sentiment, n, fill = 0) %>% # made data wide rather than narrow
  mutate(sentiment = positive - negative) # # of positive words - # of negative owrds

#Creating sentiment datasets
lyrics_bing <- tidy_lyrics %>%
  inner_join(get_sentiments("bing"))

lyrics_nrc <- tidy_lyrics %>%
  inner_join(get_sentiments("nrc"))


lyrics_nrc_sub <- tidy_lyrics %>%
  inner_join(get_sentiments("nrc")) %>%
  filter(!sentiment %in% c("positive", "negative"))

#Sentiment across entire dataset

nrc_plot <- lyrics_nrc %>%
  group_by(sentiment) %>%
  summarise(word_count = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, word_count)) %>%
  #Use `fill = -word_count` to make the larger bars darker
  ggplot(aes(sentiment, word_count, fill = -word_count)) +
  geom_col() +
  guides(fill = FALSE) + #Turn off the legend
  theme_lyrics() +
  labs(x = NULL, y = "Word Count") +
  scale_y_continuous(limits = c(0, 15000)) + #Hard code the axis limit
  ggtitle("Hip-Hop Lyrics NRC Sentiment") +
  coord_flip()

plot(nrc_plot)

bing_plot <- lyrics_bing %>%
  group_by(sentiment) %>%
  summarise(word_count = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, word_count)) %>%
  ggplot(aes(sentiment, word_count, fill = sentiment)) +
  geom_col() +
  guides(fill = FALSE) +
  theme_lyrics() +
  labs(x = NULL, y = "Word Count") +
  scale_y_continuous(limits = c(0, 8000)) +
  ggtitle("Hip-Hop Bing Sentiment") +
  coord_flip()
plot(bing_plot)

#sentiment polarity over time
lyrics_polarity_year <- lyrics_bing %>%
  count(sentiment, Year) %>%
  spread(sentiment, n, fill = 0) %>%
  mutate(polarity = positive - negative,
         percent_positive = positive / (positive + negative) * 100)

polarity_over_time <- lyrics_polarity_year %>%
  ggplot(aes(Year, polarity, color = ifelse(polarity >= 0,my_colors[5],my_colors[4]))) +
  geom_col() +
  geom_smooth(method = "loess", se = FALSE) +
  geom_smooth(method = "lm", se = FALSE, aes(color = my_colors[1])) +
  theme_lyrics() + theme(plot.title = element_text(size = 11)) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Polarity Over Time") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), text=element_text(family = "Helvetica"), plot.title = element_text(hjust = 0.5, face = "bold"))

relative_polarity_over_time <- lyrics_polarity_year %>%
  ggplot(aes(Year, percent_positive , color = ifelse(polarity >= 0,my_colors[5],my_colors[4]))) +
  geom_col() +
  geom_smooth(method = "loess", se = FALSE) +
  geom_smooth(method = "lm", se = FALSE, aes(color = my.color[1])) +
  theme_lyrics() + theme(plot.title = element_text(size = 11)) +
  xlab(NULL) + ylab(NULL) +
  ggtitle("Percent Positive Over Time") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), text=element_text(family = "Helvetica"), plot.title = element_text(hjust = 0.5, face = "bold"))

grid.arrange(polarity_over_time, relative_polarity_over_time, ncol = 2)


#Bigram analysis
hiphop_bigrams <- hiphop_data %>%
  unnest_tokens(bigram, lyrics, token = "ngrams", n = 2)

bigrams_separated <- hiphop_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word1 %in% undesirable_words) %>%
  filter(!word2 %in% undesirable_words)

#Because there is so much repetition in music, also filter out the cases where the two words are the same
bigram_decade <- bigrams_filtered %>%
  filter(word1 != word2) %>%
  filter(decade != "NA") %>%
  unite(bigram, word1, word2, sep = " ") %>%
  inner_join(hiphop_data) %>%
  count(bigram, decade, sort = TRUE) %>%
  group_by(decade) %>%
  slice(seq_len(7)) %>%
  ungroup() %>%
  arrange(decade, n) %>%
  mutate(row = row_number())

bigram_region <- bigrams_filtered %>%
  filter(word1 != word2) %>%
  filter(Region != "NA") %>%
  unite(bigram, word1, word2, sep = " ") %>%
  inner_join(hiphop_data) %>%
  count(bigram, Region, sort = TRUE) %>%
  group_by(Region) %>%
  slice(seq_len(7)) %>%
  ungroup() %>%
  arrange(Region, n) %>%
  mutate(row = row_number())

bigram_region %>%
  ggplot(aes(row, n, fill = Region)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Region, scales = "free_y") +
  xlab(NULL) + ylab(NULL) +
  scale_x_continuous(  # This handles replacement of row
    breaks = bigram_region$row, # Notice need to reuse data frame
    labels = bigram_region$bigram) +
  theme_lyrics() +
  theme(panel.grid.major.x = element_blank()) +
  ggtitle("Bigrams by Region") +
  coord_flip()

bigram_decade %>%
  ggplot(aes(row, n, fill = decade)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~decade, scales = "free_y") +
  xlab(NULL) + ylab(NULL) +
  scale_x_continuous(  # This handles replacement of row
    breaks = bigram_decade$row, # Notice need to reuse data frame
    labels = bigram_decade$bigram) +
  theme_lyrics() +
  theme(panel.grid.major.x = element_blank()) +
  ggtitle("Bigrams Per Decade") +
  coord_flip()

words <- str_split(lines, " ")

# Number of words per line
lapply(words, length)

# Number of characters in each word
word_lengths <- lapply(words, str_length)

# Average word length per line
lapply(word_lengths, mean)


# TFIDF by decade
glimpse(tidy_lyrics)

tf_idf_words <- tidy_lyrics %>% 
  count(word, decade, sort = TRUE) %>%
  bind_tf_idf(word, decade, n) %>%
  arrange(desc(tf_idf)) 

glimpse(tf_idf_words)

top_tf_idf_words <- tf_idf_words %>% 
  group_by(decade) %>%
  filter(!decade == "1980s") %>%
  top_n(12) %>%
  ungroup()

ggplot(top_tf_idf_words, aes(x = reorder(word, n), y = n, fill = decade)) +
  scale_fill_manual(values=c("azure4", "chocolate2", "cornflowerblue")) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~decade, scales = "free") +
  coord_flip() + 
  ggtitle("Unique Words By Decade") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), text=element_text(family = "Helvetica"), plot.title = element_text(hjust = 0.5, face = "bold"))

#TFIDF by region
glimpse(tidy_lyrics)

tf_idf_words2 <- tidy_lyrics %>% 
  count(word, Region, sort = TRUE) %>%
  bind_tf_idf(word, Region, n) %>%
  arrange(desc(tf_idf)) 

glimpse(tf_idf_words2)

top_tf_idf_words2 <- tf_idf_words2 %>% 
  group_by(Region) %>%
  filter(!Region == "NA") %>%
  top_n(12) %>%
  ungroup()

ggplot(top_tf_idf_words2, aes(x = reorder(word, n), y = n, fill = Region)) +
  scale_fill_manual(values=c("azure4", "chocolate2", "cornflowerblue", "firebrick3")) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~Region, scales = "free") +
  coord_flip() +
  ggtitle("Unique Words By Region") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), text=element_text(family = "Helvetica"), plot.title = element_text(hjust = 0.5, face = "bold"))


#Popular words by region
regional_words <- tidy_lyrics %>% 
  group_by(Region) %>%
  filter(!Region == "NA") %>%
  count(word, Region, sort = TRUE) %>%
  slice(seq_len(8)) %>%
  ungroup() %>%
  arrange(Region,n) %>%
  mutate(row = row_number()) 

regional_words %>%
  ggplot(aes(row, n, fill = Region)) +
  geom_col(show.legend = NULL) +
  labs(x = NULL, y = "Song Count") +
  ggtitle("Popular Words by Region") + 
  theme_lyrics() +  
  facet_wrap(~Region, scales = "free") +
  scale_x_continuous(  # This handles replacement of row 
    breaks = regional_words$row, # notice need to reuse data frame
    labels = regional_words$word) +
  coord_flip()


