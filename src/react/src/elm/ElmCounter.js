import React, { Component } from 'react';

import { Elm } from './Counter.elm'

console.dir(Elm);

const initElm = function(elmModule, flags) {
    return function(node) {
        if (node === null) return;
        // var app = elmModule.init({node: node, flags: flags});
        elmModule.init({node: node, flags: flags});
    }
}

class ElmCounter extends Component {

    shouldComponentUpdate(nextProps, nextState) {
        return false;
    }

    render() {
        const flags = {};
        const elmInit = initElm(Elm.Counter, flags)

        return (
            React.createElement('div', { ref: elmInit })
        );
    }
}

export default ElmCounter;
