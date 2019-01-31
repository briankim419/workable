import React from 'react';
import { Link } from 'react-router'

const DirectorTile = props => {

  return(
    <div>
      <h4>Director: {props.name}</h4>
      <a href={props.imdb} target="blank">Director Profile</a>
    </div>
  )
}

export default DirectorTile;
