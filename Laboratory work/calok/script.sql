SELECT * FROM ADMIN_USER.TICKER
    MATCH_RECOGNIZE (
        PARTITION BY SYMBOL ORDER BY TSTAMP
        MEASURES
            FIRST(UP.TSTAMP) AS "отмечка для начального пика",
            LAST(UP.TSTAMP) AS "отметка для конечного пика",
            FIRST(UP.PRICE) AS "начальная пиковая цена",
            LAST(UP.PRICE) AS "конечная пиковая цена"
        ONE ROW PER MATCH
        PATTERN (STRT UP+ DOWN+ UP+)
        DEFINE
            DOWN AS DOWN.PRICE < PREV(DOWN.PRICE),
            UP AS UP.PRICE > PREV(UP.PRICE)
    ) RESULT
    WHERE RESULT."конечная пиковая цена" = ( SELECT MAX(PRICE) FROM TICKER WHERE SYMBOL = RESULT.SYMBOL )
        AND RESULT."отметка для конечного пика" BETWEEN ( SELECT MIN(TSTAMP) FROM TICKER WHERE SYMBOL = RESULT.SYMBOL )
        AND ( SELECT MAX(TSTAMP) FROM TICKER WHERE SYMBOL = RESULT.SYMBOL )
    ORDER BY RESULT.SYMBOL;