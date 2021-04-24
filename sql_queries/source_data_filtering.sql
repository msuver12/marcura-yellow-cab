DECLARE statueOfLibertyLocation GEOGRAPHY DEFAULT ST_GeogPoint(-74.0474287, 40.6895436);
DECLARE maxDistance INT64 DEFAULT 3500;
DECLARE minutesIn2016 INT64 DEFAULT 527040;

WITH
    filteredData AS (
    SELECT
      passenger_count AS passengerCount,
      COUNT(*) AS numberOfTrips,
      SUM(TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE)) AS totalTimeInMinutes
    FROM
      `bigquery-public-data.new_york.tlc_yellow_trips_2016`
    WHERE
      dropoff_latitude BETWEEN -90 AND 90
      AND ST_DWithin(ST_GeogPoint(dropoff_longitude, dropoff_latitude), statueOfLibertyLocation, maxDistance)
      AND passenger_count BETWEEN 1 AND 6
    GROUP BY
      passenger_count )
    SELECT
        passengerCount,
        numberOfTrips,
        totalTimeInMinutes,
        CAST(CEILING(totalTimeInMinutes/minutesIn2016) AS INT64) AS numberOfCabsRequired
    FROM filteredData
ORDER BY
  passengerCount;