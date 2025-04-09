import consumer from './consumer';

consumer.subscriptions.create(
  { channel: 'AnswersChannel', question_id: gon.question_id },
  {
    connected() {
      return this.perform('follow');
    },
    received(data) {
      const parsedData = JSON.parse(data);

      setTimeout(() => {
        if (document.querySelector(`#answer-id-${parsedData.id}`)) {
          return;
        }

        const div = document.createElement('div');
        div.id = `answer-id-${parsedData.id}`;

        if (parsedData.best) {
          div.innerHTML = '<p>Best</p>';
        }

        div.innerHTML += `<p>${parsedData.body}</p>`;

        document.querySelector('.answers').appendChild(div);
      }, 100);
    },
  },
);
