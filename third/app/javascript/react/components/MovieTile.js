import React from 'react';
import { Link } from 'react-router'
import DirectorTile from '../components/DirectorTile'

const MovieTile = props => {

  let displayDirector = props.directorData.map(director => {
    return(
      <DirectorTile
        key={director.id}
        name={director.name}
        imdb={director.imdb}
      />
  );
  });
  return(
    <div className="movie-tile">
      <h4>Title: {props.title}</h4>
      <h4>Original Title: {props.originalTitle}</h4>
      <p>Description: {props.description}</p>
      {displayDirector}
    </div>
  );
};

export default MovieTile;
