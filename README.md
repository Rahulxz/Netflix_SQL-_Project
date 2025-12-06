# Netflix_SQL-_Project
**Problem Statement**

Netflix hosts thousands of movies and TV shows from different countries, genres, and time periods.
However, the raw dataset contains:

**Unstructured columns** (e.g., multiple countries/genres in a single field)

**Inconsistent date formats**

**Mixed data types** (e.g., "90 min", "2 Seasons")

**Missing and ambiguous values**

**Text fields requiring cleaning and classification**

The goal of this project is to use SQL to clean, transform, and analyze the Netflix dataset to answer key business questions, including:

1.What is the distribution between Movies vs. TV Shows?

2.What ratings are most common for each type of content?

3.Which countries contribute the most content?

4.What are the longest movies and highest-season TV shows?

5.How has Netflix’s content library grown in the last 5 years?

6.Which actors and directors appear most frequently?

7.How can we categorize content based on keywords like violence or kill?

8.What genres dominate the platform?

This project demonstrates how SQL can be used to generate valuable insights from real-world messy data.

 **Dataset Description**

The dataset stored in the netflix table includes the following key fields:


Netflix Solution

**show_id –** Unique identifier

**type –** Movie or TV Show

**title –** Name of the content

**director / casts –** People involved

**country –** Production country

**date_added –** When it was added to Netflix

**release_year –** Year of release

**rating –** Content rating (PG, TV-MA, etc.)

**duration –** Movie runtime or number of seasons

**listed_in –** Genres

**description –** Content summary

🛠️ Technologies Used

PostgreSQL

SQL Functions:

Window Functions (ROW_NUMBER)

String Functions (REPLACE, SPLIT_PART, string_to_array, unnest)

Date Functions (TO_DATE, EXTRACT)

Aggregation & Grouping

Common Table Expressions (CTEs)

📌 Key Analyses Performed

1️⃣ Movie vs TV Show Distribution

Compare total volumes by content type.

2️⃣ Most Common Rating per Content Type

Use window functions to identify top ratings.

3️⃣ Movies Released in a Specific Year

Filter records for year-wise analysis.

4️⃣ Top 5 Countries with the Most Content

Normalize the country field using unnest(string_to_array(...)).

5️⃣ Longest Movie on Netflix

Extract numeric duration using REPLACE() and find the maximum.

6️⃣ Content Added in the Last 5 Years

Convert string dates using to_date() and filter recent content.

7️⃣ Content Directed by ‘Rajiv Chilaka’

String search on director column.

8️⃣ TV Shows with More Than 5 Seasons

Extract season count and filter shows.

9️⃣ Content Distribution by Genre

Split multi-genre fields and count each occurrence.

🔟 Year-wise Growth of Indian Content

Measure content growth and compute percentage contributions.

1️⃣1️⃣ Documentary Movies

Filter titles tagged as documentaries.

1️⃣2️⃣ Content Missing Director Information

Identify incomplete metadata.

1️⃣3️⃣ Salman Khan Movies in the Last 10 Years

Use ILIKE for actor search and filter recent years.

1️⃣4️⃣ Top 10 Actors in India-Produced Movies

Unnest cast names and count occurrences.

1️⃣5️⃣ Classify Content as 'Good' or 'Bad' Based on Keywords

CTE that labels content referencing 'kill' or 'violence'.

**Insights Gained**

Movies dominate Netflix’s library compared to TV Shows.

"TV-MA" and "R" are among the most common content ratings.

The United States and India are leading contributors of Netflix content.

Highly seasonal shows (5+ seasons) are relatively rare.

Documentary and drama categories appear frequently.

Certain actors and directors appear in significantly higher volumes.

Keyword-based classification helps identify content themes.
