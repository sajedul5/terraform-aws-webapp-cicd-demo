// Confetti burst on load
(() => {
  const canvas = document.getElementById("confetti");
  const ctx = canvas.getContext("2d");
  const colors = ["#38bdf8", "#a78bfa", "#f472b6", "#22c55e", "#facc15"];
  let pieces = [];

  const resize = () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  };
  window.addEventListener("resize", resize);
  resize();

  const burst = (count = 150) => {
    for (let i = 0; i < count; i++) {
      pieces.push({
        x: canvas.width / 2,
        y: canvas.height / 3,
        vx: (Math.random() - 0.5) * 14,
        vy: Math.random() * -12 - 4,
        size: Math.random() * 6 + 4,
        color: colors[Math.floor(Math.random() * colors.length)],
        rot: Math.random() * 360,
        vr: (Math.random() - 0.5) * 12,
        life: 0,
      });
    }
  };

  const tick = () => {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    pieces.forEach((p) => {
      p.vy += 0.3;
      p.vx *= 0.99;
      p.x += p.vx;
      p.y += p.vy;
      p.rot += p.vr;
      p.life++;
      ctx.save();
      ctx.translate(p.x, p.y);
      ctx.rotate((p.rot * Math.PI) / 180);
      ctx.fillStyle = p.color;
      ctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size * 0.6);
      ctx.restore();
    });
    pieces = pieces.filter((p) => p.y < canvas.height + 20 && p.life < 400);
    requestAnimationFrame(tick);
  };

  if (!window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
    setTimeout(() => burst(), 600);
    document.querySelector(".card").addEventListener("click", () => burst(80));
  }
  tick();
})();
