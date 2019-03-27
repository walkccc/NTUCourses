# Comment

1. 完成度 (0~100%)

    100%。

2. coding quality (自由作答)

    通常 JavaScript convention 會用 tabsize = 2 去排版，除非同學用 vim 寫程式碼，不然推薦用 prettier，會排的很美。

3. 正確性

    100%。

4. 值得學習的地方

    功能很完整。

5. 建議改進的地方

    - 雖然沒有直接報 error，但是很多地方在 console 都看的到有 warning，例如：`React.Component` 沒有用到就該刪掉，不要 import 多餘的東西。
    - 一些多餘的 file，像是 `App.test.js` 可以砍掉。
    - `props` 往下傳遞時，可以 destructure 他，例如拿 `ListItem` 來說，`function ListItem(props) { ... }` 我會寫成 `const ListItem = ({ id, onMarkItem, done, onDeleteItem })`，這也是現在比較常見的寫法，可以避免一直重複 `props.xxx`，也比較清晰。

6. 其它心得

    - `this.setState()` 可以使用 `...` spread operator 去實現 `addTodoItem` 的功能，還有 `filter` 去實現 `onDeleteItem` 的功能。
    - 同學加油！
