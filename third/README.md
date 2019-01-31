# Workable

<br />
This application features a Ruby on Rails with a React.js stack. The purpose of the app is to be able to find currently playing movies in any countries around the world. It makes API calls to the themoviedb api to retrieve data. It uses a gem called "httparty" to assist in making api calls. Please follow the directions below to run the application on your local machine.

### Getting Started

1. Clone the workable repository to your machine.

2. Navigate to the cloned repository and then to folder "three".

3. Run the following from the command line to install all necessary dependencies:

  `$ bundle install`
  `$ yarn install`

4. Create the database and run migrations.

  `$ bundle exec rake db:create`
  `$ bundle exec rake db:migrate`

5. Start the rails server and webpack server.

  `$ rails s`

6. Navigate to localhost:3000 in your web browser. Google Chrome is recommended.
