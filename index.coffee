import { Component }  from 'react'
import { render } from 'react-dom'

import './style.sass'

class CalcYouLater extends Component
  constructor: ->
    super arguments...
    @state = buffer: ''

  solve: (str)=>
    eval str or @state.buffer

  send: (cmd)=>
    switch cmd
      when 'C'
        @setState buffer: ''
      when '+/-'
        alert 'TODO: implement'
      when '%'
        @setState buffer: @solve(@solve() + '/ 100').toString()
      when '='
        @setState buffer: @solve().toString()
      when '+', '-', '/', '*'
        # TODO: replace last operation?
        @setState buffer: @state.buffer + cmd
      else # numbers, decimal
        @setState buffer: @state.buffer + cmd

  display: =>
    try
      [..., last] = [0, ...@state.buffer.match(/([\d\.]+)/ig) ]
    catch
      last = 0
    parseFloat last

  key: (cmd, klass)=>
    <button className={"key#{klass or cmd}"} onClick={@send.bind @, cmd}>{cmd}</button>

  render: =>
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
      <div className="screen">{@state.buffer}</div>
    </div>


render <CalcYouLater/>, document.getElementById 'Application'
