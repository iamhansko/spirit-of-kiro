<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { useGameStore } from '../stores/game';

const store = useGameStore();
const visible = ref(false);
const currentMessage = ref('');
let lastNearDoorTime = 0;
const DEBOUNCE_TIME = 5000; // 5 seconds debounce

// Array of general shop messages
const messages = [
  "일하러 돌아가! 더 많은 아이템이 필요해!",
  "작업대가 널 기다리고 있어!",
  "더 많은 아이템을 제작할 시간이야!",
  "상점에 더 많은 아이템이 필요해!",
  "손님이 아이템을 기다리고 있어!",
  "날 기다리게 하지 마!",
  "작업대가 비어있어! 일하러 갑시다!",
  "판매할 아이템이 더 필요해!",
  "작업대가 텅 비어 보이네!",
  "작업을 계속해!"
];

// Array of door messages when holding an item
const doorMessagesWithItem = [
  "아, 좋은 물건이네! 이리 던져줘!",
  "완벽해! 그걸 던져주면 내가 살게!",
  "좋아 보이는데! 이쪽으로 던져줘!",
  "던져, 그 아이템을 내가 사갈게!",
  "잘했어! 이제 그걸 내게 팔아줘!"
];

// Array of door messages when not holding an item
const doorMessagesWithoutItem = [
  "왜 작업대에 가지 않아?",
  "일하러 돌아가! 더 많은 아이템이 필요해!",
  "작업대가 널 기다리고 있어!",
  "손님을 기다리게 하지 마!",
  "더 많은 아이템을 제작할 시간이야!"
];

let messageInterval: number | null = null;
let nearDoorListenerId: string | null = null;

// Check if player is holding an item
const isHoldingItem = computed(() => {
  return store.heldItemId !== null;
});

function showRandomMessage() {
  const randomIndex = Math.floor(Math.random() * messages.length);
  currentMessage.value = messages[randomIndex];
  visible.value = true;
  
  // Hide the message after 3 seconds
  setTimeout(() => {
    visible.value = false;
  }, 3000);
}

function showDoorMessage() {
  const now = Date.now();
  if (now - lastNearDoorTime < DEBOUNCE_TIME) return;
  lastNearDoorTime = now;
  
  const messages = isHoldingItem.value ? doorMessagesWithItem : doorMessagesWithoutItem;
  const randomIndex = Math.floor(Math.random() * messages.length);
  currentMessage.value = messages[randomIndex];
  visible.value = true;
  
  // Hide the message after 3 seconds
  setTimeout(() => {
    visible.value = false;
  }, 3000);
}

onMounted(() => {
  // Show first message after 5 seconds
  setTimeout(() => {
    showRandomMessage();
  }, 5000);
  
  // Set up interval to show messages every 60 seconds
  messageInterval = window.setInterval(() => {
    if (!store.interactionLocked) { // Only check for dialogs being open
      showRandomMessage();
    }
  }, 60000);

  // Listen for near-door event
  nearDoorListenerId = store.addEventListener('near-door', () => {
    showDoorMessage();
  });
});

onUnmounted(() => {
  if (messageInterval) {
    clearInterval(messageInterval);
  }
  if (nearDoorListenerId) {
    store.removeEventListener('near-door', nearDoorListenerId);
  }
});
</script>

<template>
  <div v-if="visible" class="random-chat">
    <div class="chat-bubble">
      {{ currentMessage }}
    </div>
  </div>
</template>

<style scoped>
.random-chat {
  position: absolute;
  bottom: 5%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
}

.chat-bubble {
  background-color: rgba(0, 0, 0, 0.7);
  color: #ddd;
  padding: 10px 15px;
  border-radius: 15px;
  font-size: 1.2em;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
  white-space: nowrap;
  animation: fadeIn 0.5s ease-in;
}

.chat-bubble:after {
  content: '';
  position: absolute;
  bottom: -10px;
  left: 50%;
  transform: translateX(-50%);
  border-left: 10px solid transparent;
  border-right: 10px solid transparent;
  border-top: 10px solid rgba(0, 0, 0, 0.7);
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style> 