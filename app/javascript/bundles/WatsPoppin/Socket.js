import ActionCable from 'actioncable';

export default class Socket {
  constructor() {
    this.cable = ActionCable.createConsumer('/cable');
  }
  // onNewStories function comes from home component
  setupSubscription = onNewStories => {
    this.cable.subscriptions.create(
      {
        channel: 'StoriesChannel'
      },
      {
        received: data => {
          // function receives new data and updates the state
          onNewStories(data);
        }
      }
    );
  };
}
