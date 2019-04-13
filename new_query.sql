WITH dates AS (
SELECT
    t.user_id,
    MIN(t.created_date) as min_date
FROM
    transactions t
WHERE
  t.state = 'COMPLETED' AND
  t.type = 'CARD_PAYMENT'
GROUP BY 1
),

amounts AS (
SELECT
    CASE WHEN t.currency!='USD'
         THEN f.rate * t.amount
         ELSE 1 * t.amount
    END AS amount,
    t.user_id,
    t.id,
    t.merchant_country,
    t.merchant_category,
    d.min_date
FROM transactions t
JOIN dates d ON t.user_id =d.user_id AND
    t.created_date=d.min_date
JOIN fx_rates f ON t.currency=f.base_ccy AND
    f.ts < d.min_date
)

SELECT
*
FROM amounts a
WHERE a.amount > 10
LIMIT 50
