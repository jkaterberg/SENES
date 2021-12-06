# SENES

Strava except not exactly Strava. Created for the final project in CSCI 4100U. SENES is intended to be an outdoor exercise oriented app. The primary feature will be location tracking for activities using maps and tracking the speed and distance. Information will be saved locally on the device. We intend to deploy this app on android for ease of development purposes. This app could be impactful in the sense that there is no intention of implementing a subscription service which the vast majority of similar apps have. We don’t think that it should cost $15 a month just to view the data of your runs, or to implement a schedule/plan. Many of these apps do not allow for customized schedules and only offer premium ones that you need the subscription for. A leading apps in this category is Strava. This app is incredibly popular due to the social media elements of following other users and interacting with their posts. This is a feature that we are not going to implement as it is intended to be used individually. For the purpose of this project we will not include functionality with wearable technology in order to keep the scope in a manageable range.

## Objectives

- Track routes taken during runs/rides/hikes on maps
- Log data about the workout
  - Route
  - Duration
  - Average speed
  - Elevation gain/loss
  - Current environmental conditions in the area
- Allow users to view past workouts
- Compare data from workouts to help track progress
  - Graph data to help identify trends
- Schedule Workouts
- Send notifications to encourage them to be active

## Progress

Check the Issues tab to see what is currently being worked on

## Running

1. Setup a Flutter development environment ([guide](docs.flutter.com/get-started/install))
2. Setup and run an Android emulator
3. Clone this repo: `git clone https://github.com/jkaterberg/SENES.git && cd SENES/senes`
4. Rename .env_sample to .env and paste MapBox and OpenWeather API stuff in the appropriate places
5. Run via flutter command line tool: `flutter run`
