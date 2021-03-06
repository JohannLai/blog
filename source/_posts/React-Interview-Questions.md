title: React 常见的面试题（在 React 里面，你可以知道也可以不知道的事, 但是你会发现他们确实很有用）
date: 2017-03-14 7：00：06
categories:
- 技术
- 翻译
tags:
- React
---

根据记录，问这些问题可能不是深入了解他们在使用 React 方面的经验的最佳方式。
之所以标题是《 React 常见的面试题》，其实只是想起一个比《在 React 里面，你可以知道也可以不知道的事, 但是你会发现他们确实很有用》要简单明了的标题而已。

<img src="https://tylermcginnis.com/react-interview-questions/react-interview-questions.jpg" alt="React 常见的面试题">


<Excerpt in index | 首页摘要> 
+ <!-- more -->
<The rest of contents | 余下全文>


原文链接：[React Interview Questions
](https://tylermcginnis.com/react-interview-questions/)

作者： Tyler.Google Developer Expert and a partner at React Training where we teach React online

翻译：[Johann Lai](http://johannlai.com)



## 当你调用 **setState** 的时候，发生了什么事？

当调用 `setState` 时，React会做的第一件事情是将传递给 `setState` 的对象合并到组件的当前状态。这将启动一个称为一致化处理（reconciliation）的过程。一致化处理（reconciliation）的最终目标是以最有效的方式，根据这个新的状态来更新UI。 为此，React将构建一个新的 `React` 元素树（您可以将其视为 UI 的对象表示）。
一旦有了这个树，为了弄清 UI 如何响应新的状态而改变，React 会将这个新树与上一个元素树相比较（**diff**）。   

（译注：一致化处理（reconciliation）可理解为 React 内部将虚拟 DOM 同步更新到真实 DOM 的过程，包括新旧虚拟 DOM 的比较及计算最小 DOM 操作）

通过这样， React 将会知道发生的确切变化，并且了解发生什么变化以后，只需在绝对必要的情况下进行更新，即可最小化 UI 的占用空间。

-------------------------------------

## 在 React 当中  Element 和  Component 有何区别？

简单地说，一个 **React  element** 描述了你想在屏幕上看到什么。换个说法就是，一个 **React  element**  是一些 UI 的对象表示。

一个 **React Component** 是一个函数或一个类，它可以接受输入并返回一个 **React  element** （通常是通过 JSX ，它被转化成一个 createElement 调用）。

有关更多信息，请查看 [React Elements vs React Components](https://tylermcginnis.com/react-elements-vs-react-components/)

-------------------------------------


## 什么时候在功能组件( Functional Component )上使用类组件( Class Component)？

如果您的组件具有状态( state )或生命周期方法，请使用 Class 组件。否则，使用功能组件。

-------------------------------------


## 什么是 React 的 refs ，为什么它们很重要？

**refs** 就像是一个逃生舱口，允许您直接访问DOM元素或组件实例。为了使用它们，您可以向组件添加一个 **ref** 属性，该属性的值是一个回调函数，它将接收底层的 DOM 元素或组件的已挂接实例，作为其第一个参数。

```JavaScript
class UnControlledForm extends Component {
  handleSubmit = () => {
    console.log("Input Value: ", this.input.value)
  }
  render () {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type='text'
          ref={(input) => this.input = input} />
        <button type='submit'>Submit</button>
      </form>
    )
  }
}
```
以上注意到我们的输入字段有一个 **ref** 属性，其值是一个函数。该函数接收放在实例上实际的 DOM 元素 input，以便在 *handleSubmit* 函数内部访问它。经常被误解的是，您需要使用类组件才能使用**ref** ，但 **ref** 也可以通过利用 `JavaScript` 中的**闭包**与 功能组件( functional components )一起使用。


```JavaScript
function CustomForm ({handleSubmit}) {
  let inputElement
  return (
    <form onSubmit={() => handleSubmit(inputElement.value)}>
      <input
        type='text'
        ref={(input) => inputElement = input} />
      <button type='submit'>Submit</button>
    </form>
  )
}
```
-------------------------------------


## React 中的 **keys** 是什么，为什么它们很重要？

**keys** 是帮助 React 跟踪哪些项目已更改、添加或从列表中删除的属性。

```javascript
  return (
    <ul>
      {this.state.todoItems.map(({task, uid}) => {
        return <li key={uid}>{task}</li>
      })}
    </ul>
  )
}
```

每个**keys** 在兄弟元素之间是独一无二的。我们已经谈过几次关于一致化处理（reconciliation）的过程，而且这个一致化处理过程（reconciliation）中的一部分正在执行一个新的元素树与最前一个的差异。**keys** 使处理列表时更加高效，因为 React 可以使用子元素上的 **keys** 快速知道元素是新的还是在比较树时才被移动的。

而且 **keys** 不仅使这个过程更有效率，而且没有**keys**，React 不知道哪个本地状态对应于移动中的哪个项目。所以当你 map 的时候，不要忽略了 **keys** 。

## 看下面的代码: 如果您在 <Twitter /> 下创建了一个 React 元素，<Twitter />的组件定义将如何？

```JavaScript
<Twitter username='tylermcginnis33'>
  {(user) => user === null
    ? <Loading />
    : <Badge info={user} />}
</Twitter>

```


```JavaScript
import React, { Component, PropTypes } from 'react'
import fetchUser from 'twitter'
// fetchUser接收用户名返回 promise
// 当得到 用户的数据的时候 ，返回resolve 状态

class Twitter extends Component {
  // 在这里写下你的代码
}
```

如果你不熟悉渲染回调模式（render callback pattern），这将看起来有点奇怪。在这种模式中，一个组件接收一个函数作为它的 child。注意上面包含在 <Twitter>标签内的内容。*Twitter* 组件的 child 是一个函数，而不是你曾经习以为常的一个组件。 这意味着在实现 *Twitter* 组件时，我们需要将 *props.children* 作为一个函数来处理。 

以下是我的答案。

```JavaScript
import React, { Component, PropTypes } from 'react'
import fetchUser from 'twitter'

class Twitter extends Component {
  state = {
    user: null,
  }
  static propTypes = {
    username: PropTypes.string.isRequired,
  }
  componentDidMount () {
    fetchUser(this.props.username)
      .then((user) => this.setState({user}))
  }
  render () {
    return this.props.children(this.state.user)
  }
}
```

**值得注意的是**，正如我上面提到的，我通过调用它并传递给 user 来把 props.children 处理为一个函数。

这种模式的好处是我们已经将我们的父组件与我们的子组件分离了。父组件管理状态，父组件的消费者可以决定以何种方式将从父级接收的参数应用于他们的 UI。


为了演示这一点，我们假设在另一个文件中，我们要渲染一个 *Profile* 而不是一个 *Badge,*，因为我们使用渲染回调模式，所以我们可以轻松地交换 UI ，而不用改变我们对父（Twitter）组件的实现。

```JavaScript
<Twitter username='tylermcginnis33'>
  {(user) => user === null
    ? <Loading />
    : <Profile info={user} />}
</Twitter>
```

## 受控组件( controlled component )与不受控制的组件( uncontrolled component )有什么区别？

React 的很大一部分是这样的想法，即组件负责控制和管理自己的状态。


当我们将 native HTML 表单元素（ input, select, textarea 等）投入到组合中时会发生什么？我们是否应该使用 React 作为“单一的真理来源”，就像我们习惯使用React一样？ 或者我们是否允许表单数据存在 DOM 中，就像我们习惯使用HTML表单元素一样？ 这两个问题是受控（controlled） VS 不受控制（uncontrolled）组件的核心。

**受控**组件是React控制的组件，也是表单数据的唯一真理来源。

如下所示，*username* 不存在于 DOM 中，而是以我们的组件状态存在。每当我们想要更新 *username* 时，我们就像以前一样调用setState。

```javascript
class ControlledForm extends Component {
  state = {
    username: ''
  }
  updateUsername = (e) => {
    this.setState({
      username: e.target.value,
    })
  }
  handleSubmit = () => {}
  render () {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type='text'
          value={this.state.username}
          onChange={this.updateUsername} />
        <button type='submit'>Submit</button>
      </form>
    )
  }
}
```

不受控制( uncontrolled component )的组件是您的表单数据由 DOM 处理，而不是您的 React 组件。

我们使用 **refs** 来完成这个。
```JavaScript
class UnControlledForm extends Component {
  handleSubmit = () => {
    console.log("Input Value: ", this.input.value)
  }
  render () {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type='text'
          ref={(input) => this.input = input} />
        <button type='submit'>Submit</button>
      </form>
    )
  }
}
```

虽然不受控制的组件通常更容易实现，因为您只需使用引用从DOM获取值，但是通常建议您通过不受控制的组件来支持受控组件。

主要原因是受控组件**支持即时字段验证**，允许您有条件地禁用/启用按钮，强制输入格式，并且更多的是 『the React way』。

## 在哪个生命周期事件中你会发出 AJAX 请求，为什么？

AJAX 请求应该在 `componentDidMount` 生命周期事件中。 有几个原因:

- Fiber，是下一次实施React的和解算法，将有能力根据需要启动和停止渲染，以获得性能优势。其中一个取舍之一是 `componentWillMount`，而在其他的生命周期事件中出发 AJAX 请求，将是具有 “非确定性的”。 这意味着 React 可以在需要时感觉到不同的时间开始调用 componentWillMount。这显然是AJAX请求的不好方式。

- 您不能保证在组件挂载之前，AJAX请求已经 resolve。如果这样做，那意味着你会尝试在一个未挂载的组件上设置 SetState，这不仅不会起作用，反而会对你大喊大叫。 在 `componentDidMount` 中执行 AJAX 将保证至少有一个要更新的组件。

## shouldComponentUpdate 应该做什么，为什么它很重要？

上面我们讨论了 reconciliation ，什么是 React 在 setState 被调用时所做的。在生命周期方法 shouldComponentUpdate 中，允许我们选择退出某些组件（和他们的子组件）的 reconciliation  过程。

我们为什么要这样做？

如上所述，“一致化处理（ reconciliation ）的最终目标是以最有效的方式，根据新的状态更新用户界面”。如果我们知道我们的用户界面（UI）的某一部分不会改变，那么没有理由让 React 很麻烦地试图去弄清楚它是否应该渲染。通过从 shouldComponentUpdate 返回 false，React 将假定当前组件及其所有子组件将保持与当前组件相同。

## 您如何告诉React 构建（build）生产模式，该做什么？

通常，您将使用Webpack的 *DefinePlugin* 方法将 **NODE_ENV** 设置为 production。这将剥离像 propType 验证和额外的警告。除此之外，还有一个好主意，可以减少你的代码，因为React使用 Uglify 的 dead-code 来消除开发代码和注释，这将大大减少你的包的大小。

## 为什么要使用 React.Children.map（props.children，（）=>） 而不是 props.children.map（（）=>）

因为不能保证props.children将是一个数组。 

以此代码为例，
```JavaScript
<Parent>
  <h1>Welcome.</h1>
</Parent>
```

在父组件内部，如果我们尝试使用 props.children.map 映射孩子，则会抛出错误，因为 props.children 是一个对象，而不是一个数组。

如果有多个子元素，React 只会使props.children成为一个数组。就像下面这样：

```JavaScript
<Parent>
  <h1>Welcome.</h1>
  <h2>props.children will now be an array</h2>
</Parent>
```

这就是为什么你喜欢 `React.Children.map`，因为它的实现考虑到 `props.children` 可能是一个数组或一个对象。

## 描述事件在React中的处理方式。

为了解决跨浏览器兼容性问题，您的 React 中的事件处理程序将传递`SyntheticEvent` 的实例，它是 React 的浏览器本机事件的跨浏览器包装器。

这些 `SyntheticEvent` 与您习惯的原生事件具有相同的接口，除了它们在所有浏览器中都兼容。有趣的是，React 实际上并没有将事件附加到子节点本身。React 将使用单个事件监听器监听顶层的所有事件。这对于性能是有好处的，这也意味着在更新DOM时，React 不需要担心跟踪事件监听器。

## createElement 和 cloneElement 有什么区别？

createElement 是 JSX 被转载到的，是 React 用来创建 React Elements 的内容(一些 UI 的对象表示)cloneElement用于克隆元素并传递新的 props。他们钉住了这两个🙂的命名。

## 可以选择性地传递给 setState 的第二个参数是什么，它的目的是什么？


一个回调函数，当setState结束并`re-rendered`该组件时将被调用。一些没有说出来的东西是 setState 是**异步**的，这就是为什么它需要一个第二个回调函数。通常最好使用另一个生命周期方法，而不是依赖这个回调函数，但是很高兴知道它存在。

```JavaScript
this.setState(
  { username: 'tylermcginnis33' },
  () => console.log('setState has finished and the component has re-rendered.')
)
```

## 这段代码有什么问题？
```ＪavaScript
this.setState((prevState, props) => {
  return {
    streak: prevState.streak + props.count
  }
})
```
没毛病。但是这种写法很少被使用，并不是众所周知的，就是你也可以传递一个函数给setState，它接收到先前的状态和道具并返回一个新的状态，正如我们在上面所做的那样。它不仅没有什么问题，而且如果您根据以前的状态（state）设置状态，推荐使用这种写法。
