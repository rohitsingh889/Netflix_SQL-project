# Netflix_SQL-project
SQL-based analysis of Netflix dataset: Movies, TV Shows, Actors, Genres, and Trends.


![Netflix_Logo](https://github.com/rohitsingh889/Netflix_SQL-project/blob/main/logo.png)

# Netflix SQL Analysis Project

This project is a comprehensive analysis of the Netflix dataset using **SQL**. The analysis covers movies, TV shows, actors, directors, genres, and content trends over the years.

## Features & Analysis

1. **Basic Exploration**
   - Total number of movies and TV shows
   - Unique ratings and types
   - Overview of data for verification

2. **Content Analysis**
   - Count of Movies vs TV Shows
   - Most common ratings per type
   - Movies released in a specific year
   - Longest movies and TV shows with >5 seasons

3. **Geographical Analysis**
   - Top countries by number of shows
   - Average content release per year in India

4. **Actor & Director Analysis**
   - Top actors by number of movies in India
   - Movies/TV shows by specific directors
   - Content without a director

5. **Genre & Category Analysis**
   - Count of content per genre
   - Categorize content as Good or Bad based on keywords like "Kill" and "Violence"
   - List of Documentaries

6. **Time-based Analysis**
   - Content added in the last 5 years
   - Last 10 years' movies by specific actors

## Tools & Techniques
- **SQL (PostgreSQL)** for all queries
- Advanced SQL features used: `UNNEST`, `STRING_TO_ARRAY`, `RANK()`, `WINDOW FUNCTIONS`, `CTE`
- Data cleaning and transformation handled within SQL

## How to Use
1. Clone this repository.
2. Import the `netflix` dataset into PostgreSQL.
3. Run the SQL queries in order to reproduce the analysis.

## Insights
- Understand trends in Netflix content by type, country, and genre.
- Identify top actors, directors, and popular ratings.
- Categorize content for sensitive keywords.

