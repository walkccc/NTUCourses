## Completion Rate： 95%

## Coding quality

1. 運用 Faker 製作資料我覺得很好！讓 code 變得很簡潔;
2. 右上角的 account 有點問題，href 使用 `./`，對觸控不是很友善，每次點都會重整;
    ```html
    <a href="./" className="navbar-link">
    Account
    </a>
    ```
3. route 最好最後有個 `<Route path="*" component={NOTFOUND} />` 來 handle 404 page;
