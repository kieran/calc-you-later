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

  solve: (str)=>
    {left, op, right} = @state
    return unless left and op and right

    @setState(
      left:   eval([parseFloat(left), op, parseFloat(right)].join ' ').toString()
      op:     null
      right:  null
    )

  writeTarget: =>
    return 'right' if @state.right?.length or @state.op?.length
    'left'

  append: (val)=>
    target = @writeTarget()
    @setState "#{target}": [@state["#{target}"],val].join ''

  invert: =>
    target = @writeTarget()
    return unless @state["#{target}"]?
    @setState "#{target}": (parseFloat(@state["#{target}"]) * -1).toString()

  clear: =>
    @setState left: null, op: null, right: null

  percentify: =>
    target = @writeTarget()
    return unless @state["#{target}"]?
    @setState "#{target}": (parseFloat(@state["#{target}"]) / 100).toString()

  send: (cmd)=>
    switch cmd
      when 'C'    then @clear()
      when '+/-'  then @invert()
      when '%'    then @percentify()
      when '='    then @solve()
      when '+', '-', '/', '*'
        if @state.right?.length # solve, then set new op
          @solve()
          @setState op: cmd # potentially overwrite op
        else if @state.left?.length
          @setState op: cmd # potentially overwrite op
      when '.'
        @append cmd unless cmd in @display()
      else # numbers, decimal
        @append cmd

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