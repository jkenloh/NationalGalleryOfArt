-- 1) What timeframe or time period are most of the artworks created from?
-- Using COUNT(*) to account for NULL values
-- Created a 'percentage' column to show percentage of total counts
SELECT visualBrowserTimeSpan, COUNT(*) AS count, ROUND(CAST(COUNT(*) AS REAL)/(SELECT COUNT(*) FROM objects), 4) * 100 AS percentage
FROM objects
GROUP BY visualBrowserTimeSpan
ORDER BY count DESC;

----------

-- 2) Who are the artists with the most works at the NGA?
SELECT attribution, COUNT(*) AS count
FROM objects
GROUP BY attribution
ORDER BY count DESC
LIMIT 10;

----------

-- 3) What is the breakdown of the types of artworks in the NGA collection? (e.g., painting, print, sculpture, photograph, etc.)
SELECT subClassification, COUNT(*) AS count,
	ROUND(CAST(COUNT(*) AS REAL)/(SELECT COUNT(*) FROM objects), 4) * 100 AS percentage
FROM objects
GROUP BY subClassification
ORDER BY count DESC;

----------

-- 4) Where were most of these artworks sourced from? (e.g., collections, funds, donors)
SELECT classification, COUNT(*) AS count, 
	ROUND(CAST(COUNT(*) AS REAL)/(SELECT COUNT(*) FROM objects), 4) * 100 AS percentage
FROM objects
GROUP BY classification
ORDER BY count DESC
LIMIT 10;

----------

-- 5) Who were the most active constituents to the NGA?
SELECT c.lastname, forwardDisplayName, COUNT(lastName) AS count
FROM objects AS o
INNER JOIN objects_constituents AS oc
ON o.objectID = oc.objectID
INNER JOIN constituents AS c
ON oc.constituentID = c.constituentID
GROUP BY c.lastName
ORDER BY count DESC
LIMIT 20;

----------

-- 6) How many Canadian artists are represented in the NGA collection?
-- Filtering artistOfNGAObject = 1 for artist of an NGA accessioned object, as per NGA provided Data Dictionary
-- Filtering for lastName NOT NULL as there was an organization listed without a last name, and we only want individuals
SELECT lastName, forwardDisplayName, nationality
FROM constituents AS c
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND lastName NOT NULL;

----------

-- 7) How many total art pieces are attributed to Canadian artists?
SELECT COUNT(*) AS count
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter');

----------

-- 8) How many art pieces are attributed to each Canadian artist?
SELECT forwardDisplayName, COUNT(*) AS count
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter') 
GROUP BY forwardDisplayName
ORDER BY count DESC;

----------

-- 9) What is the breakdown of the types of artworks by Canadian artists? (e.g., painting, print, sculpture, photograph, etc.)
-- CTE used to calculate percentage of the total count
WITH total_cte(total_count)
AS
(
SELECT COUNT(*)
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
WHERE artistOfNGAObject = 1
	AND c.nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter')
)
SELECT o.subClassification AS art_type, COUNT(*) AS count, ROUND(CAST(COUNT(*) AS REAL)/(SELECT * FROM total_cte), 4) * 100 AS percentage 
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND c.nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter')
GROUP BY o.subClassification
ORDER BY count DESC;

----------

-- 10) In which time period were these artworks by Canadian artists predominantly created?
SELECT o.visualBrowserTimeSpan, COUNT(*) AS count
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter')
GROUP BY o.visualBrowserTimeSpan
ORDER BY count DESC;

-- Curious to see oldest Canadian art piece
SELECT forwardDisplayName, title, MIN(o.beginYear), subClassification
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter') 
ORDER BY lastName;

-- Latest?
SELECT forwardDisplayName, title, MAX(o.beginYear), subClassification
FROM constituents AS c
INNER JOIN objects_constituents AS oc
ON c.constituentID = oc.constituentID
INNER JOIN objects AS o
ON oc.objectID = o.objectID
WHERE artistOfNGAObject = 1
	AND nationality = 'Canadian' AND (oc.role = 'artist' OR oc.role = 'painter') 
ORDER BY lastName;