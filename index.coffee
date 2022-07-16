import { Component }  from 'react'
import { render } from 'react-dom'

import './style.sass'

class CalcYouLater extends Component
  constructor: ->
    super arguments...
    @state =
      left:   null
      op:     null
      right:  null

  componentDidMount: =>
    document.addEventListener 'keyup', @keyUp

  componentWillUnmount: =>
    document.removeEventListener 'keyup', @keyUp

  keyUp: ({key})=>
    @send key

  solve: =>
    {left, op, right} = @state
    return unless left and op and right

    left =  parseFloat left
    right = parseFloat right

    val = \
    switch op
      when '+' then left + right
      when '-' then left - right
      when '*' then left * right
      when '/' then left / right

    @setState(
      left:   "#{val}"
      op:     null
      right:  null
    )

  writeTarget: =>
    return 'right' if @state.right?.length or @state.op?.length
    'left'

  append: (val)=>
    target = @writeTarget()

    # don't allow edits to Infinity or NaN (which are valid Numbers)
    return unless Number.isInteger parseFloat @state[target] or 0

    @setState "#{target}": "#{@state[target] or ''}#{val}"

  invert: =>
    target = @writeTarget()
    return unless @state[target]?
    @setState "#{target}": "#{-1 * parseFloat @state[target]}"

  setOp: (op)=>
    @setState { op }

  clear: =>
    @setState left: null, op: null, right: null

  percentify: =>
    target = @writeTarget()
    return unless @state[target]?
    @setState "#{target}": "#{1/100 * parseFloat @state[target]}"

  send: (cmd)=>
    switch cmd
      when 'C', 'c', 'Clear'
        @clear()
      when '+/-'
        @invert()
      when '%'
        @percentify()
      when '=', 'Enter'
        @solve()
      when '+', '-', '/', '*'
        @solve()    # try to solve if possible
        @setOp cmd  # potentially overwrite op
      when '.'
        @append cmd unless cmd in @display()
      else # numbers
        @append cmd if "#{cmd}" is "#{parseFloat cmd}"

  display: =>
    {right, left} = @state
    right or left or '0'

  key: (cmd, klass)=>
    <button className={"key#{klass or cmd}"} onClick={@send.bind @, cmd}>{cmd}</button>

  render: =>
    <>
      <div className="CalcYouLater">
        <div className="screen">{@display()}</div>
        <div className="keyboard">
          {@key 'C'}
          {@key '+/-', 'sign'}
          {@key '%', 'percent'}
          {@key '/', 'divide'}
          <br/>
          {@key 7}
          {@key 8}
          {@key 9}
          {@key '*', 'times'}
          <br/>
          {@key 4}
          {@key 5}
          {@key 6}
          {@key '-', 'minus'}
          <br/>
          {@key 1}
          {@key 2}
          {@key 3}
          {@key '+', 'plus'}
          <br/>
          {@key 0}
          {@key '.', 'dot'}
          {@key '=', 'equals'}
        </div>
      </div>
      <code><pre>{JSON.stringify @state, null, 2}</pre></code>
    </>


render <CalcYouLater/>, document.getElementById 'Application'
