<script setup lang="ts">
const openSourceCode = () => {
  window.open('https://github.com/kirodotdev/spirit-of-kiro/', '_blank')
}

const openGuide = () => {
  window.open('https://kiro.dev/docs/guides/learn-by-playing/', '_blank')
}
</script>

<template>
  <div class="home">
    <div class="hero">
      <div class="hero-content">
        <img src="../assets/kiro-ghost/south.png" alt="Ghost" class="ghost-image" />
        <div class="hero-text">
          <h1>Spirit of Kiro</h1>
          <p class="tagline">무한한 가능성을 상상해 보세요</p>
          <div class="button-group">
            <router-link to="/play" class="play-button">
              탐험 시작하기
            </router-link>
            <div class="utility-buttons">
              <button class="source-button" @click="openSourceCode">소스코드</button>
              <button class="guide-button" @click="openGuide">가이드</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="content">
      <div class="section">
        <p class="large-text">모든 아이템에는 이야기가 있습니다. 모든 발견은 새로운 세상을 밝힙니다. 잊혀진 아이템들이 새로운 의미를 찾는 마법의 세계로 당신을 초대합니다.</p>
      </div>

      <div class="features">
        <div class="feature">
          <h3>진귀한 보물</h3>
          <p>AI가 생성하는 모든 아이템은 유일무이합니다. 모든 발견은 오직 당신만의 것입니다.</p>
        </div>
        <div class="feature">
          <h3>영원한 연금술</h3>
          <p>아이템들을 결합해 정교한 작품을 만들거나, 분해해서 태초의 정수까지 되돌리세요.</p>
        </div>
        <div class="feature">
          <h3>다이나믹한 상호작용</h3>
          <p>당신의 발견이 전혀 예상치 못한 행동과 반응으로 생생하게 살아나는 모습을 지켜보세요.</p>
        </div>
      </div>

      <div class="section">
        <h2>Your journey awaits.</h2>
        <p class="large-text">수집하세요. 조사하세요. 변형하세요. 당신의 행동에 따라 공방은 끊임없이 진화합니다.</p>
      </div>
    </div>
  </div>
</template>

<style scoped>
.home {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: linear-gradient(135deg, #0f0f0f 0%, #1a1a1a 100%);
  color: white;
  text-align: center;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
}

.hero {
  padding: 6rem 2rem 3rem;
  width: 100%;
  max-width: 1200px;
  min-height: 80vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.content {
  width: 100%;
  max-width: 1200px;
  padding: 0 2rem 6rem;
}

h1 {
  font-size: 5.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #fff 0%, #a0a0a0 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  letter-spacing: -0.02em;
}

h2 {
  font-size: 3rem;
  font-weight: 600;
  margin-bottom: 1.5rem;
  letter-spacing: -0.02em;
}

.tagline {
  font-size: 1.8rem;
  color: #888;
  margin-bottom: 2.5rem;
  font-weight: 400;
  letter-spacing: 0.02em;
}

.large-text {
  font-size: 1.4rem;
  line-height: 1.4;
  color: #888;
  max-width: 800px;
  margin: 0 auto 3rem;
}

.section {
  margin-bottom: 6rem;
  padding: 0 2rem;
}

.features {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 2rem;
  margin: 3rem 0;
  padding: 0 2rem;
}

.feature {
  padding: 2rem;
  background-color: rgba(255, 255, 255, 0.02);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.feature:hover {
  transform: translateY(-4px);
  background-color: rgba(255, 255, 255, 0.04);
  border-color: rgba(255, 255, 255, 0.1);
}

.feature h3 {
  margin-bottom: 1rem;
  color: #fff;
  font-size: 1.6rem;
  font-weight: 600;
  letter-spacing: -0.01em;
}

.feature p {
  font-size: 1.1rem;
  color: #888;
  line-height: 1.6;
}

.play-button {
  display: inline-block;
  padding: 1.2rem 4rem;
  font-size: 1.5rem;
  font-weight: 500;
  text-decoration: none;
  color: white;
  background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
  border-radius: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: none;
  box-shadow: 0 4px 20px rgba(76, 175, 80, 0.2);
}

.play-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 25px rgba(76, 175, 80, 0.3);
  background: linear-gradient(135deg, #45a049 0%, #4CAF50 100%);
}

.button-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
}

.utility-buttons {
  display: flex;
  gap: 1rem;
}

.source-button {
  padding: 0.8rem 2rem;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 500;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
  display: inline-block;
  box-shadow: 0 2px 10px rgba(33, 150, 243, 0.2);
}

.source-button:hover {
  background-color: #1976D2;
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
}

.guide-button {
  padding: 0.8rem 2rem;
  background-color: #FF9800;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 500;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
  display: inline-block;
  box-shadow: 0 2px 10px rgba(255, 152, 0, 0.2);
}

.guide-button:hover {
  background-color: #F57C00;
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
}

.hero-content {
  display: flex;
  align-items: flex-start;
  gap: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
}

.hero-text {
  flex: 1;
  position: relative;
}

.ghost-image {
  width: 180px;
  height: auto;
  filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.2));
  position: absolute;
  left: -160px;
  top: 0;
  animation: float 2s ease-in-out infinite;
}

@keyframes float {
  0% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-8px);
  }
  100% {
    transform: translateY(0);
  }
}

@media (max-width: 768px) {
  .hero {
    padding: 4rem 1rem 2rem;
    min-height: 70vh;
  }

  .content {
    padding: 0 1rem 4rem;
  }

  h1 {
    font-size: 3.5rem;
  }

  h2 {
    font-size: 2.2rem;
  }

  .tagline {
    font-size: 1.4rem;
    margin-bottom: 2rem;
  }

  .large-text {
    font-size: 1.2rem;
  }

  .features {
    grid-template-columns: 1fr;
    padding: 0 1rem;
  }

  .section {
    padding: 0 1rem;
    margin-bottom: 3rem;
  }

  .play-button {
    padding: 1rem 3rem;
    font-size: 1.3rem;
  }

  .hero-content {
    flex-direction: column;
    gap: 1rem;
  }

  .ghost-image {
    position: relative;
    left: 0;
    top: 0;
    width: 120px;
    margin: 0 auto;
  }

  .utility-buttons {
    flex-direction: column;
    gap: 0.8rem;
  }

  .source-button,
  .guide-button {
    padding: 0.7rem 1.5rem;
    font-size: 0.9rem;
  }
}
</style>