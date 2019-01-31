import React from 'react'
import { Route, IndexRoute, Router, browserHistory } from 'react-router';
import MovieIndexContainer from '../containers/MovieIndexContainer';

export const App = (props) => {
  return (
    <Router history={browserHistory}>
      <Route path='/' component={MovieIndexContainer} />
    </Router>
  );
}


export default App
