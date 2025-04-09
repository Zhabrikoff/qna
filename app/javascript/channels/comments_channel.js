import consumer from './consumer';

consumer.subscriptions.create(
  { channel: 'CommentsChannel', question_id: gon.question_id },
  {
    connected() {
      return this.perform('follow');
    },
    received(data) {
      const parsedData = JSON.parse(data);

      setTimeout(() => {
        if (document.querySelector(`#comment-id-${parsedData.id}`)) {
          return;
        }

        const li = document.createElement('li');
        li.id = `comment-id-${parsedData.id}`;

        const p = document.createElement('p');
        p.textContent = parsedData.body;

        li.appendChild(p);

        const container = document.querySelector(
          `#${parsedData.commentable_type.toLowerCase()}-id-${parsedData.commentable_id} .comments ul`,
        );

        if (!container) {
          const commentable = document.querySelector(
            `#${parsedData.commentable_type.toLowerCase()}-id-${parsedData.commentable_id} .comments`,
          );
          const ul = document.createElement('ul');
          commentable.appendChild(ul);
          ul.appendChild(li);
        } else {
          container.appendChild(li);
        }
      }, 100);
    },
  },
);
