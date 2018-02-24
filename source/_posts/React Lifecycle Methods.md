title: React 的生命周期的使用场景
date: 2017-03-14 7：00：06
categories:
- 技术
- 翻译
tags:
- React
---
<img src="https://cdn-images-1.medium.com/max/2000/1*XcGM-8E_hGl4fpAr9wJIsA.png" >
<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


原文链接： [React Lifecycle Methods- how and when to use them
](https://engineering.musefind.com/react-lifecycle-methods-how-and-when-to-use-them-2111a1b692b1)
作者： Scott DomesFollow  Front-End/Mobile Developer @ MuseFind.
翻译： [johannlai](http://johannlai.com)

上面这个图片，就是 **React** 组件的生命周期，从形成 (pre-mounting)到销毁 (unmounting)的过程。

**React** 的优雅之处就在于，它把复杂的 UI 分解成很小的部分。 我们不仅仅可以划分我们的应用，而且我们还可以定制我们每一个组件。

通过组件的生命周期方法，我们可以控制当UI的每个微小部分渲染，更新，重新渲染，直到完全消失时会发生什么事情。

让我们开始吧！

## componentWillMount 

您的组件将很快就会出现在屏幕上面。这个渲染功能与其所有精美的 JSX 一样，即将被调用。那你想做用她来做什么？

答案是...  `componentWillMount` 用处不会太大。

componentWillMount 所处的生命周期是，没有组件可以玩，所以你不能做任何涉及DOM的事情。（译者：因为还没渲染组件）

此外，自从您组件的构造函数（ constructor  ）被调用以来，没有任何变化，但是，无论如何，您至少应该可以在`componentWillMount` 的时候设置组件的默认配置。

```JavaScript
  export default calss Sidebar extends Component {
    constructor(props) {
      super(props)
      this.state = {
        analyticsOpen: false,
        requirementsOpen: false,
        barndInfoOpen: false
      }
    }
  }
```

现在您的组件处于默认位置，所以不需要额外的生命周期方法，几乎所有的东西都应该由其余的组件代码来处理。

例外的是，你需要的是只能在运行时完成的任何设置，说白了也就是连接到外部 API 。举个栗子，如果您的应用程序使用 Firebase ，则需要在应用程序首次挂载（mounting）时进行设置。

但关键是，这样的配置应该在应用程序的最高级别组件（根组​​件）的进行。 这意味着99％的组件应该不能使用 `componentWillMount` 。

您可能会看到有人使用`componentWillMount`启动 AJAX 调用来加载组件的数据。 **千万不要这样做**，我们马上就会聊到这个。

**接下来，更有用的方法是：**
**最常见的用例：** 您的根组件中的应用程序配置。
**可以调用setState：**不要。改用默认状态（ default state ）。


## componentDidMount

现在您的组件在那里，挂载了并准备好使用了。接下来你将要进行什么操作 ？

这里是您加载数据的位置。我会让 [Tyler McGinnis](https://twitter.com/tylermcginnis33) 解释为什么：

> You can’t guarantee the AJAX request won’t resolve before the component mounts. If it did, that would mean that you’d be trying to setState on an unmounted component, which not only won’t work, but React will yell at you for. Doing AJAX in componentDidMount will guarantee that there’s a component to update.

> 您不能保证在组件挂载之前，AJAX请求已经 resolve 。如果这样做，那意味着你会尝试在一个未挂载的组件上设置 SetState，这不仅不会起作用，反而 React 会对你大喊大叫。在 componentDidMount 中执行 AJAX 将保证至少有已经渲染的组件需要更新。

`ComponentDidMount` 是一个允许你做很多你平时在没有组件的时候不能做的事情。 下面举几个栗子：
- 绘制您刚刚渲染的<canvas>元素
- 从元素集合初始化 masonry 网格布局
- 增加事件监听器

基本上，你可以在这里做任何刚刚因为没有 DOM 而不能做的设置，并且可以获取你所需要的全部数据。

**最常见的用例：** 启动`AJAX`调用，以加载组件的数据。
**可以调用setState**：是的。


## componentWillReceiveProps

我们的组成部分工作得很好，突然之间，一大堆新的 `props` 到达了，使到组件处于混乱状态。

这很有可能是一些由父组件的`componentDidMount`加载的数据终于到达，并被传递下来。

在我们的组件对新的 `props` 进行任何操作之前，将用下一`props` 作为参数调用`componentWillReceiveProps`。

<img alt="componentWillReceiveProps" src="https://cdn-images-1.medium.com/max/800/1*u3rXB0qKor51Qb_R1laPjw.png"

现在，我们正在处于一个很有趣的地方，我们可以（通过nextProps）访问下一个 `props` 和（通过this.props）访问我们当前的 `props` 。

下面这些是我们在`componentWillReceiveProps` 中需要做的：
- 检查哪些`props` 会改变（使用componentWillReceiveProps的警告 - 有时它什么也没有改变时被调用; React 只是想做一个检查）
- 如果`props` 会以重要的方式改变 `props`，就行动。

下面是一个例子。假设我们在上面提到，我们有一个 <canvas> 元素。假设我们根据 `this.props.percent` 绘制一个很好的圆形图形。

<img src="https://cdn-images-1.medium.com/max/800/1*SXFIS2pwJ0znpmBjDUfxCQ.png" alt="看起来很不错" >

当我们收到新的`props` ，例如百分比发生变化，我们想重新绘制网格。可以参考以下代码：

```javascript
  componentWillReceiveProps( nextProp ) {
    if(this.props.percent !== nextProps.percent) {
      this.setUpCirCle(nextProps.percent)
    }
  }
```
**注意：** 在初始渲染时不调用 componentWillReceiveProps 。
我的意思是在技术上，组件正在接收`props`，但没有任何旧的`props`要比较，所以...不算。

最常见的用例：根据特定的`props`，更改来触发状态（state）转换。
是否可以调用`setState`: Yes


## shouldComponentUpdate

现在我们的组件越来越紧张了。

我们有新的`props`。典型的`React`教条告诉我们，当一个组件接收到新的`props`或新的`state`时，它应该更新。

但是我们的组件会先征求我们的同意。

这是我们所需要的 —— `shouldComponentUpdate`方法，以 `nextProps` 为第一个参数，`nextState`是第二个参数：
```javascript
shouldComponentUpdate(nextProps, nextState) {
  return this.props.engagement !== nextProps,engagement
    || nextState.input !== this.state.input
}
```

shouldComponentUpdate应该总是返回一个布尔值 —— 就像这个问题的答案 
--> “我可以渲染吗？”
--> 是的，小组件，你可以去渲染。

默认情况下它总是返回`true`。

如果您担心浪费渲染，那么 shouldComponentUpdate 是您提高性能的好地方。

我以这种方式写了一篇关于使用shouldComponentUpdate的文章 - 看看：

> [How to Benchmark React Components: The Quick and Dirty Guide](https://engineering.musefind.com/how-to-benchmark-react-components-the-quick-and-dirty-guide-f595baf1014c)

在这篇文章中，我们谈论一个有很多 fields 的表格。他遇到的问题是，当表重新渲染时，每个字段也将重新渲染，速度很慢，效率很低。

`ShouldComponentUpdate`允许这样操作：只有当所关心的`props`的改变的时候才更新！

> 但请记住，如果您设置并忘记它，可能会导致重大问题，因为您的React组件将无法正常更新。所以谨慎使用。


**最常见的用例：** 当您的组件 `re-render` (重新渲染)时，完全控制。
**是否可以调用`setState`:**  No

## componentWillUpdate

哇，现在我们允许更新了。"希望我在重新渲染之前先做任何事情?" 我们的组件问。不，我们说。停止打扰我们。

在整个 MuseFind 代码库中，我们从不使用 componentWillUpdate。在功能上，它基本上与`componentWillReceiveProps`相同，除非你不允许调用`this.setState`。

如果您正在使用`shouldComponentUpdate` 并且需要在`props`更改时执行某些操作，那么`componentWillUpdate`才会很有意义。

**最常见的用例：** 在一个也有shouldComponentUpdate（但不能访问以前的`props`）的组件上使用而不是`componentWillReceiveProps`。

**是否可以调用`setState`:**  No


## componentDidUpdate
很棒！小组件！

在这里我们可以和`componentDidMount`做同样的事情 ： 重新设置我们的 masonry 布局，重绘我们的canvas,等。


等等 - 我们没有在`componentWillReceiveProps`中重画我们的`canvas`吗？

是的我们没有这样做。原因是：`在componentDidUpdate` 中，你不知道为什么它更新。

因此，如果我们的组件接收到的`canvas`数量超过了与我们的`canvas`相关的`props`，我们不希望每次更新时都会浪费时间重绘`canvas`上面。

这并不意味着`componentDidUpdate`没有用。要回到我们的 masonry 布局示例，我们要在DOM自身更新后重新排列网格，所以我们使用`componentDidUpdate`来完成。
```javascript
componentDidUpdate() {
  this.createGrid()
}
```

**最常见的用例：**更新DOM以响应`prop`或`state`更改。
**是否可以调用`setState`:**  Yes

## componentWillUnmount

几乎结束了~

你的组件将会消失。也许永远，这很伤心。

在它离开之前，它仍然会询问你是否有任何最后的请求。

在这里，您可以取消任何传出的网络请求，或删除与组件关联的所有事件监听器。

基本上，清理任何只涉及到有关的组件的事情，
当它走了，它应该完全消失。

```javascript
componentWillUnmount() {
  window.removeEventListen('resize', this,resizeListener)
}
```

**最常见的用例：**清理组件中残留的残留物。
**是否可以调用`setState`:**  No

## 总结

在理想的世界中，我们不会使用生命周期方法。我们所有的渲染问题都将通过`state` 和 `prop`进行控制。

事实上并不存在一个理想的世界，有时您需要更准确地控制组件更新的方式和时间。

谨慎使用这些方法，并小心使用。我希望这篇文章有助于阐明什么时候和如何使用生命周期方法。
