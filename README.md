# Elections and Race in King County
## INFO 201 "Foundational Skills for Data Science"
## Spring 2024
## Author: Ryder Forsythe

**Link to official version: https://rf-uw.shinyapps.io/INFO201Final/**

**Link to plotly-less version (that can actually run): https://rf-uw.shinyapps.io/INFO201Final_plotlyless/**


# Introduction

This project examines the last decade and a half of elections in King County, and how they have been correlated with race and ethnicity as measured by the U.S. Census Bureau. Since 2008, King County has undergone several major electoral realignments alongside the rest of the country. As the largest county in Washington State, and one of the largest and most diverse in the country, changes in its electoral landscape reflect several broader trends in political affiliation and electoral participation. In the past decade, traditional political divides have shifted, correlated in part with race. Using electoral and demographic data from the past 16 years, I want to explore and answer these research questions:

#### 1. What is the racial geography of King County?
#### 2. What is the electoral geography of King County? How has this changed over time?
#### 3. How is race correlated with changes in the electoral landscape of King County?

Analyzing these topics can help us to better understand not only how politics and electoral coalitions are changing, but *why* - and how they may continue to shift in the coming election - not only in King County or Washington State, but in the United States as a whole.


# Conclusions

### 1. King County is very blue, and getting bluer

We can see this in the second chart, as well as in the overall data - King County has shifted very strongly to the left over time. In 2012, King County voted for Barack Obama (D) over Mitt Romney (R) by a margin of 40.36 percentage points. In 2020, it voted for Joe Biden (D) over Donald Trump (R) by 52.71 percentage points. This is a more than twelve point shift to the left, driven in large part by the leftward shift of white, suburban areas. Even just from 2016 to 2020, the county shifted four percentage points to the left. This swing has not been uniform, however.

### 2. There has been a rightward shift in majority-minority areas

Even though King County as a whole has shifted quite a lot to the left, many nonwhite communities have moved in the opposite direction. From the first map, we can see that Black Americans, Hispanic Americans, Asian-Americans, and Pacific Islanders are mostly concentrated in South Seattle and the southern King County suburbs, with a substantial Asian population also residing in the suburbs east of Seattle. Most of these areas shifted to the right from 2012 to 2020, despite the county as a whole moving in the opposite direction. This suggests that there has been a significant realignment of nonwhite voters towards the Republican Party, which is also visible in shifts between more recent election results, like the swing from the 2020 Presidential election to the 2022 Senate election. These trends are also visible in the scatterplots - nonwhite % of the population is meaningfully correlated with rightward swings.


### 3. Not all plurality-nonwhite areas shifted to the right

We can see from the 2012 - 2020 swing map that many plurality- or majority-Asian areas on the Eastside actually shifted left, even as similarly Asian precincts in the south shifted to the right. This indicates that there might be more going on here than just a race-based realignment. Rather, it seems like the ultimate cause of these swings might be something correlated with race but distinct from it. My best guess is that the culprit is educational attainment.


### Broader Implications
Polarization based on educational attainment is a well-documented and highly discussed phenomenon in national politics; the New York Times' Nate Cohn argues that educational polarization is the defining political trend of this era. One thing those leftward-swinging Asian neighborhoods have in common with their majority-white counterparts is very high levels of college education. Ultimately, I think that more study is needed to determine what this relationship might be; unfortunately, information about educational attainment is far less granular than Census data, so getting clear answers may be difficult. What is clear, however, is that there are realignments taking place in these communities, regardless of the cause, and this has implications for the political landscape of not just King County, but the whole country.
