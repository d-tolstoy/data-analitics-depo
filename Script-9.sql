--домашнее задание №2

--1
SELECT 
    Artist.Name, 
    COUNT(Album.AlbumId) AS AlbumCount
FROM 
    Artist 
JOIN 
    Album ON Artist.ArtistId = Album.ArtistId
GROUP BY 
    Artist.Name
HAVING 
    COUNT(Album.AlbumId) >= 3;

--2
SELECT 
    Customer.CustomerId, 
    Customer.FirstName, 
    Customer.LastName, 
    SUM(Invoice.Total) AS Total_Spend
FROM 
    Customer 
JOIN 
    Invoice ON Invoice.CustomerId = Invoice.CustomerId
GROUP BY 
    Customer.CustomerId, Customer.FirstName, Customer.LastName;

--3
SELECT 
    Invoice.InvoiceId, 
    COUNT(InvoiceLine.InvoiceLineId) AS Line_Count
FROM 
    Invoice 
JOIN 
    InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY 
    Invoice.InvoiceId;

--4
SELECT 
    Customer.FirstName, 
    Customer.LastName, 
    SupportRep.FirstName AS SupportName, 
    SupportRep.LastName AS SupportLastName
FROM 
    Customer 
JOIN 
    Employee AS SupportRep ON Customer.SupportRepId = SupportRep.EmployeeId
WHERE 
    SupportRep.Title LIKE '%support%';

--5
SELECT 
    Track.Name, 
    Genre.Name AS GenreName, 
    Track.MilliSeconds
FROM 
    Track 
JOIN 
    Genre ON Track.GenreId = Genre.GenreId
WHERE 
    Track.TrackId IN (
        SELECT TrackId 
        FROM Track AS T 
        WHERE T.GenreId = Track.GenreId 
        ORDER BY T.MilliSeconds DESC 
        LIMIT 1);

--6
SELECT 
    Album.AlbumId, 
    Album.Title
FROM 
    Album 
JOIN 
    Track ON Album.AlbumId = Track.AlbumId
GROUP BY 
    Album.AlbumId
HAVING 
    MIN(Track.UnitPrice) > (SELECT AVG(UnitPrice) 
FROM Track 
WHERE AlbumId = Album.AlbumId);

--7
SELECT 
    Invoice.InvoiceId, 
    COUNT(InvoiceLine.InvoiceLineId) AS Line_Count
FROM 
    Invoice 
JOIN 
    InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
GROUP BY 
    Invoice.InvoiceId
ORDER BY
    Line_Count DESC;

--8
SELECT 
    Track.Name, 
    MediaType.Name AS MediaTypeName, 
    COUNT(InvoiceLine.TrackId) AS Top_sale
FROM 
    Track 
JOIN 
    InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
JOIN 
    MediaType ON Track.MediaTypeId = MediaType.MediaTypeId
GROUP BY 
    Track.TrackId, MediaType.Name
ORDER BY 
    MediaType.Name
LIMIT 3;

--9
WITH ArtistInfo AS (
    SELECT ArtistId FROM Artist WHERE Name = 'ac/dc'
),
ArtistTracks AS (
    SELECT DISTINCT t.TrackId 
    FROM Track t
    JOIN Album a ON t.AlbumId = a.AlbumId
    WHERE a.ArtistId = (SELECT ArtistId FROM ArtistInfo)
),
CustomerTrackCounts AS (
    SELECT
        i.CustomerId,
        COUNT(DISTINCT il.TrackId) AS NumberOfTracksBought
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    WHERE il.TrackId IN (SELECT TrackId FROM ArtistTracks)
    GROUP BY i.CustomerId
),
TotalTrackCount AS (
    SELECT COUNT(*) AS TotalCount FROM ArtistTracks
)
SELECT
    c.CustomerId,
    c.FirstName,
    c.LastName
FROM
    Customer c
JOIN
    CustomerTrackCounts ctc ON c.CustomerId = ctc.CustomerId
CROSS JOIN
    TotalTrackCount ttc
WHERE
    ctc.NumberOfTracksBought = ttc.TotalCount;