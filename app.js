(() => {
  const D = window.HAULR;
  const $ = (s) => document.querySelector(s);
  const state = { service: "junk", size: 2, sort: "trust", onlyVerified: true, compare: new Set(), searched: false };

  const fmt = (n) => "$" + Math.round(n).toLocaleString();
  const trustScore = (p) => {
    // 60 pts from checks, 30 from rating, 10 from track record
    const checks = (p.verified.length / D.checks.length) * 60;
    const rating = ((p.rating - 3) / 2) * 30;
    const volume = Math.min(p.jobs / 1000, 1) * 10;
    return Math.max(0, Math.round(checks + rating + volume));
  };
  const relevantChecks = (service) => D.checks.filter((c) => c.key !== "disposal" || service === "junk");
  const fullyVerified = (p, service) => relevantChecks(service).every((c) => p.verified.includes(c.key));
  const price = (p) => D.services[state.service].base[state.size - 1] * p.priceMult;
  const etaText = (h) => (h <= 6 ? `Today, ~${h}h` : h <= 24 ? "Tomorrow" : `In ${Math.round(h / 24)} days`);

  function renderChecks() {
    $("#checks").innerHTML = D.checks
      .map((c) => `<div class="check-card"><div class="badge">✓</div><h3>${c.title}</h3><p>${c.body}</p></div>`)
      .join("");
  }

  function renderSearch() {
    const svc = D.services[state.service];
    document.querySelectorAll(".tab").forEach((t) => t.classList.toggle("active", t.dataset.service === state.service));
    $("#size-label").textContent = svc.sizeLabel;
    $("#size-desc").textContent = svc.sizes[state.size - 1];
    const b = svc.base[state.size - 1];
    $("#estimate").textContent = `${fmt(b * 0.85)} – ${fmt(b * 1.15)}`;
  }

  function sorted() {
    let list = D.providers.filter((p) => p.services.includes(state.service));
    if (state.onlyVerified) list = list.filter((p) => fullyVerified(p, state.service));
    const key = { trust: (p) => -trustScore(p), price: (p) => price(p), eta: (p) => p.eta }[state.sort];
    return list.sort((a, b) => key(a) - key(b));
  }

  function card(p) {
    const score = trustScore(p);
    const checks = relevantChecks(state.service)
      .map((c) => `<li class="${p.verified.includes(c.key) ? "ok" : "miss"}">${p.verified.includes(c.key) ? "✓" : "–"} ${c.title}</li>`)
      .join("");
    return `
      <article class="pro card">
        <div class="score ${score >= 85 ? "high" : score >= 70 ? "mid" : "low"}"><b>${score}</b><small>Trust</small></div>
        <div class="pro-main">
          <h3>${p.name}</h3>
          <p class="meta">★ ${p.rating} · ${p.jobs.toLocaleString()} booked jobs · ${p.years} yrs</p>
          <p>${p.blurb}</p>
          <ul class="checks">${checks}</ul>
        </div>
        <div class="pro-side">
          <div class="price">${fmt(price(p))}<small>locked price</small></div>
          <div class="eta">${etaText(p.eta)}</div>
          <button class="btn primary" data-book="${p.id}">Book</button>
          <label class="check small"><input type="checkbox" data-compare="${p.id}" ${state.compare.has(p.id) ? "checked" : ""}/> Compare</label>
        </div>
      </article>`;
  }

  function renderList() {
    const list = sorted();
    const svc = D.services[state.service];
    const zip = $("#zip").value;
    $("#results-title").textContent = `${svc.label} pros${zip ? " near " + zip : ""} · ${svc.sizes[state.size - 1]}`;
    $("#list").innerHTML = list.length
      ? list.map(card).join("")
      : `<p class="empty">No fully verified pros for this yet. Uncheck "Fully verified only" to see crews still finishing their checks.</p>`;
    renderCompareBar();
  }

  function renderCompareBar() {
    const n = state.compare.size;
    $("#compare-bar").classList.toggle("hidden", n < 2);
    $("#compare-count").textContent = `${n} selected`;
  }

  function openModal(html) {
    $("#modal-body").innerHTML = html;
    $("#modal").showModal();
  }

  function bookModal(p) {
    const svc = D.services[state.service];
    openModal(`
      <h2>Book ${p.name}</h2>
      <p class="meta">${svc.label} · ${svc.sizes[state.size - 1]} · ${$("#date").value || "date TBD"}</p>
      <div class="lock">Locked price <b>${fmt(price(p))}</b><br/><small>If the crew asks for more on the day, Haulr refunds the difference.</small></div>
      <form id="book-form" class="stack">
        <input placeholder="Full name" required />
        <input type="tel" placeholder="Phone" required />
        <input placeholder="Street address" required />
        <textarea placeholder="Anything heavy, stairs, parking notes?"></textarea>
        <button class="btn primary" type="submit">Confirm booking</button>
      </form>`);
    $("#book-form").addEventListener("submit", (e) => {
      e.preventDefault();
      openModal(`<h2>You're booked.</h2><p>${p.name} will confirm within 15 minutes. Payment is held by Haulr and released only after you mark the job done.</p>`);
    });
  }

  function compareModal() {
    const ps = D.providers.filter((p) => state.compare.has(p.id));
    const rows = [
      ["Trust Score", (p) => trustScore(p)],
      ["Locked price", (p) => fmt(price(p))],
      ["Arrival", (p) => etaText(p.eta)],
      ["Rating", (p) => `★ ${p.rating}`],
      ["Booked jobs", (p) => p.jobs.toLocaleString()],
      ...relevantChecks(state.service).map((c) => [c.title, (p) => (p.verified.includes(c.key) ? "✓" : "–")]),
    ];
    openModal(`
      <h2>Compare</h2>
      <div class="table-wrap"><table>
        <thead><tr><th></th>${ps.map((p) => `<th>${p.name}</th>`).join("")}</tr></thead>
        <tbody>${rows.map(([label, f]) => `<tr><td>${label}</td>${ps.map((p) => `<td>${f(p)}</td>`).join("")}</tr>`).join("")}</tbody>
      </table></div>`);
  }

  // events
  document.querySelectorAll(".tab").forEach((t) =>
    t.addEventListener("click", () => {
      state.service = t.dataset.service;
      state.compare.clear();
      renderSearch();
      if (state.searched) renderList();
    })
  );
  $("#size").addEventListener("input", (e) => {
    state.size = +e.target.value;
    renderSearch();
    if (state.searched) renderList();
  });
  $("#search").addEventListener("submit", (e) => {
    e.preventDefault();
    state.searched = true;
    renderList();
    $("#book").scrollIntoView({ behavior: "smooth" });
  });
  $("#sort").addEventListener("change", (e) => { state.sort = e.target.value; renderList(); });
  $("#only-verified").addEventListener("change", (e) => { state.onlyVerified = e.target.checked; renderList(); });
  $("#list").addEventListener("click", (e) => {
    const id = +e.target.dataset.book;
    if (id) bookModal(D.providers.find((p) => p.id === id));
  });
  $("#list").addEventListener("change", (e) => {
    const id = +e.target.dataset.compare;
    if (!id) return;
    e.target.checked ? state.compare.add(id) : state.compare.delete(id);
    renderCompareBar();
  });
  $("#compare-btn").addEventListener("click", compareModal);
  $("#modal-close").addEventListener("click", () => $("#modal").close());
  $("#pro-form").addEventListener("submit", (e) => {
    e.preventDefault();
    $("#pro-msg").textContent = "Got it. We'll email you the verification checklist within one business day.";
    e.target.reset();
  });

  // init
  const tomorrow = new Date(Date.now() + 864e5).toISOString().slice(0, 10);
  $("#date").min = new Date().toISOString().slice(0, 10);
  $("#date").value = tomorrow;
  $("#year").textContent = new Date().getFullYear();
  renderChecks();
  renderSearch();
  renderList();
})();
