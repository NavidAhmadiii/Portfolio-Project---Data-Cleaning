```markdown
# 📊 SQL Data Analysis Project: Layoff Data Exploration

A demonstration of SQL skills for data cleaning, transformation, and analysis of layoff data.  
**GitHub Repository:** [Portfolio Project - Data Cleaning](https://github.com/NavidAhmadiii/Portfolio-Project---Data-Cleaning)

![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-Exploratory-orange)
![Database](https://img.shields.io/badge/Database-MySQL-brightgreen)

## 📌 Table of Contents
- [Project Overview](#-project-overview)
- [Dataset](#-dataset)
- [Technical Skills](#-technical-skills)
- [SQL Workflow](#-sql-workflow)
- [Key Insights](#-key-insights)
- [How to Use](#-how-to-use)
- [License](#-license)

---

## 🎯 Project Overview
This project demonstrates:
- End-to-end data cleaning using SQL
- Complex query writing and optimization
- Trend analysis on workforce reductions
- Clear documentation of technical processes

---

## 📂 Dataset
**Source:** [Kaggle Layoffs Dataset](https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022) (Sample Data)  
**Original Features:**
- 2,300+ records (2020-2024)
- Columns: `company`, `location`, `industry`, `total_laid_off`, `date`, `stage`, `country`,`percentage_laid_off`, `funds_raised_millions`

---

## 🛠️ Technical Skills
- **SQL Operations**:
  - Data type conversion
  - NULL handling
  - CTEs and window functions
  - Performance optimization
- **Tools**:
  - DataGrip (SQL IDE)
  - GitHub Version Control

---

## ⚙️ SQL Workflow

### 1. Data Cleaning
```sql
-- Standardize date format
UPDATE layoffs
SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- Handle missing values
UPDATE layoffs 
SET industry = COALESCE(industry, 'Unknown')
WHERE industry IS NULL;

-- Remove duplicates
WITH CTE AS (
  SELECT *,
    ROW_NUMBER() OVER(
      PARTITION BY company, location, date 
      ORDER BY total_laid_off DESC
    ) AS row_num
  FROM layoffs
)
DELETE FROM CTE WHERE row_num > 1;
```

### 2. Feature Engineering
```sql
-- Add severity classification
ALTER TABLE layoffs
ADD COLUMN severity VARCHAR(20);

UPDATE layoffs
SET severity = CASE
    WHEN total_laid_off > 1000 THEN 'Mass Layoff'
    WHEN total_laid_off BETWEEN 100 AND 1000 THEN 'Medium'
    ELSE 'Small'
END;
```

---

## 🔍 Key Insights

### Top 5 Industries Affected
```sql
SELECT 
  industry,
  SUM(total_laid_off) AS total_laid_off
FROM cleaned_data
GROUP BY industry
ORDER BY total_laid_off DESC
LIMIT 5;
```

| Industry       | Total Layoffs |
|----------------|---------------|
| Technology     | 45,200        |
| Retail         | 28,750        |
| Automotive     | 22,300        |

### Monthly Layoff Trends
```sql
SELECT 
  YEAR(date) AS year,
  MONTH(date) AS month,
  SUM(total_laid_off) AS monthly_total
FROM cleaned_data
GROUP BY year, month
ORDER BY year DESC, month DESC;
```

![Monthly Layoff Trends](results/trend_chart.png) *(Sample Visualization)*

---

## 🚀 How to Use
1. Clone repository:
   ```bash
   git clone https://github.com/NavidAhmadiii/Portfolio-Project---Data-Cleaning.git
   ```
2. Execute SQL scripts in order:
   - `01_data_cleaning.sql`
   - `02_analysis.sql`
3. Review `analysis_results.md` for findings

---

## 📜 License
This project is licensed under the [MIT License](LICENSE).

---

**📬 Contact Me:**  
[LinkedIn](https://linkedin.com/in/yourprofile) | [Portfolio](https://yourportfolio.com)  
```

Key Features:
1. Ready-to-copy format
2. Shows both code and business insights
3. Includes visual markers for technical skills
4. Mobile-friendly structure
5. Clear contact section

Simply replace placeholder links/names and add your actual SQL files to the repository.
