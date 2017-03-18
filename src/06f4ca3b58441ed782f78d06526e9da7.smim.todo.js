const base = '/sap/ztodo';
const Link = ReactRouter.Link;

function handleError(evt, callback) {
  if (evt.target.status === 200) {
    callback(JSON.parse(evt.target.responseText).DATA);
  } else {
    alert("REST call failed, status: " + evt.target.status);
  }
}

class REST {
  static root = base + "/rest/";

  static list(callback) {
    let oReq = new XMLHttpRequest();
    oReq.addEventListener("load", (evt) => { handleError(evt, callback); });
    oReq.open("GET", this.root + "list");
    oReq.send();
  }
}

class List extends React.Component {
  constructor() {
    super();
    this.state = {data: null};
    REST.list(this.update.bind(this));
  }

  update(d) {
    this.setState({data: d});
  }

  item(e) {
    return (<li>{e.TEXT}</li>);
  } 
      
  render() {
    return (
      <div>
      <h1>todo list</h1>
      <ul>
      {this.state.data?this.state.data.map(this.item):"loading"}
      </ul>
      <br />
      <a href={base + "/rest/swagger.html"}>swagger</a>
      </div>);
  }
}

class Router extends React.Component {
        
  render() { 
    const history = ReactRouter.useRouterHistory(History.createHistory)({ basename: base });
      
    return (
      <ReactRouter.Router history={history} >
        <ReactRouter.Route path="/">
          <ReactRouter.IndexRoute component={List} />
        </ReactRouter.Route>
      </ReactRouter.Router>);
  }
}
      
ReactDOM.render(<Router />, document.getElementById('app'));