import {
    createContext, h
} from "https://unpkg.com/preact@latest?module";

import {
    useReducer,
    useContext,
} from "https://unpkg.com/preact@latest/hooks/dist/hooks.module.js?module";

import htm from "https://unpkg.com/htm?module";
const html = htm.bind(h);

const rainbow = [
    "#9400d3",
    "#4b0082",
    "#0000ff",
    "#00ff00",
    "#ffff00",
    "#ff7f00",
    "#ff0000",
    "#000000"
];

export function getRainbow() {
    return new Array(8)
        .fill()
        .map((_, i) =>
            new Array(4).fill({ visibile: true, color: rainbow[i] })
        );
}
export const logsMiddleware = reducers => (state, action) => {
    console.group(action.type);
    console.info(state);
    console.info("payload:", action.payload);
    const newState = reducers(state, action);
    console.log(newState);
    console.groupEnd();
    return newState;
};

export function reducers(state, action) {
    switch (action.type) {
        case "COPY_FROM_ORIGIN":
            return {
                ...state,
                grid: Array(8)
                    .fill()
                    .map(() => Array(4).fill().map(_ => state.grid[0][0]))
            };
        case "SET_RAINBOW":
            return {
                ...state,
                grid: getRainbow()
            };
        case "SET_COLOR":
            const { color, x, y } = action.payload;
            state.grid[y][x] = {color};
            return {
                ...state
            };
        case "GET_INFO":
            return {
                ...state,
                info: action.payload
            }
        default:
            return state;
    }
}


const Context = createContext();

export function Provider({ reducers, initialState, children }) {
    const [state, dispatch] = useReducer(reducers, initialState);

    return html`
          <${Context.Provider} value=${{ state, dispatch }}>
            ${children}
          <//>
        `;
}

export const connect = component => props => {
    const { state, dispatch } = useContext(Context);

    return component({
        ...props,
        ...state,
        dispatch
    });
};