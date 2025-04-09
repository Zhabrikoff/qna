import consumer from './consumer';

consumer.subscriptions.create('QuestionsChannel', {
  connected() {
    return this.perform('follow');
  },
  received(data) {
    const parsedData = JSON.parse(data);

    setTimeout(() => {
      if (document.querySelector(`#question-id-${parsedData.id}`)) {
        return;
      }

      const div = document.createElement('div');
      div.id = `question-${parsedData.id}`;

      div.innerHTML = `
        <p>rating: ${parsedData.rating}</p>
        <h2>
          <a href="/questions/${parsedData.id}">${parsedData.title}</a>
        </h2>
        <p>${parsedData.body}</p>
      `;

      document.querySelector('.questions').appendChild(div);
    }, 100);
  },
});
