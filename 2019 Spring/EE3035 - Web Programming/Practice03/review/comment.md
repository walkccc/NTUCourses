# Comment

1. 完成度 (0~100%)

    100%。

2. coding quality (自由作答)

    `Main.js` 的部分行數太多了，通常 React 會再多拆分成幾個 components，這樣之後要 reuse 也比較方便。

3. 正確性

    100%。

4. 值得學習的地方

    主題很美。

5. 建議改進的地方

    - 在 react 中，HTML tag 裡的 `class` 應改為 `className`，不然會和 JavaScript 的 `class` 保留字相衝。
    - 一些多餘的 file，像是 `App.test.js` 可以砍掉。

6. 其它心得

    - 寫 JavaScript 的 convention 很重要，通常會習慣 tabsize = 2 spaces，這樣才不會一下子一行變的很長，可以用 prettier 來排版，我滿推薦的。
    - 在會需要重複渲染許多重複 components 時（例如：`tag`、`className` 都一樣，只有差在 `img` 的來源），我會盡量用 `map` 去實現，不然一直重複寫一樣的程式碼，不僅難閱讀、維護，也不容易擴充。）
