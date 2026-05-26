<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Ruminae PPC Dashboard</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<style>
  :root {
    --orange: #e87722;
    --orange-light: #f5a623;
    --orange-dark: #c45e0a;
    --bg: #fff;
    --text: #222;
    --muted: #666;
    --border: #e0e0e0;
    --row-alt: #fff8f3;
    --green: #2e7d32;
    --amber: #f57c00;
    --red: #c62828;
    --green-bg: #e8f5e9;
    --amber-bg: #fff3e0;
    --red-bg: #ffebee;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif; background: #f5f5f5; color: var(--text); color-scheme: light; }
  
  /* Header */
  .header { background: var(--orange); color: #fff; padding: 16px 24px; display: flex; align-items: center; gap: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.2); }
  .header h1 { font-size: 1.4rem; font-weight: 700; letter-spacing: 0.5px; }
  .header .sub { font-size: 0.85rem; opacity: 0.85; margin-top: 2px; }
  .logo { width: 42px; height: 42px; background: #fff; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 1.1rem; color: var(--orange); }
  
  /* Nav */
  .nav { background: #fff; border-bottom: 2px solid var(--border); display: flex; overflow-x: auto; }
  .nav-btn { padding: 14px 20px; border: none; background: none; cursor: pointer; font-size: 0.88rem; font-weight: 600; color: var(--muted); border-bottom: 3px solid transparent; margin-bottom: -2px; white-space: nowrap; transition: all 0.2s; }
  .nav-btn:hover { color: var(--orange); background: #fff8f3; }
  .nav-btn.active { color: var(--orange); border-bottom-color: var(--orange); }
  
  /* Sections */
  .section { display: none; padding: 24px; max-width: 1400px; margin: 0 auto; }
  .section.active { display: block; }
  
  /* Week badge */
  .week-badge { display: inline-flex; align-items: center; gap: 6px; background: var(--orange); color: #fff; padding: 4px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; margin-bottom: 20px; }
  
  /* KPI Cards */
  .cards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 14px; margin-bottom: 24px; }
  .card { background: #fff; border-radius: 10px; padding: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); border-left: 4px solid var(--orange); }
  .card .label { font-size: 0.75rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; }
  .card .val { font-size: 1.5rem; font-weight: 700; color: var(--text); }
  .card .delta { font-size: 0.78rem; margin-top: 4px; }
  .delta.up { color: var(--green); }
  .delta.down { color: var(--red); }
  .delta.neutral { color: var(--muted); }
  
  /* Overview comparison */
  .overview-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }
  @media(max-width:700px){ .overview-grid{ grid-template-columns:1fr; } }
  .week-block { background: #fff; border-radius: 10px; padding: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
  .week-block h3 { font-size: 1rem; font-weight: 700; color: var(--orange); border-bottom: 2px solid var(--orange); padding-bottom: 8px; margin-bottom: 14px; }
  .kpi-row { display: flex; justify-content: space-between; align-items: center; padding: 7px 0; border-bottom: 1px solid var(--border); font-size: 0.88rem; }
  .kpi-row:last-child { border-bottom: none; }
  .kpi-label { color: var(--muted); }
  .kpi-val { font-weight: 700; color: var(--text); }
  
  /* Charts */
  .charts-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; margin-bottom: 24px; }
  .chart-card { background: #fff; border-radius: 10px; padding: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
  .chart-card h4 { font-size: 0.85rem; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; }
  
  /* Tables */
  .table-wrap { background: #fff; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
  .table-toolbar { padding: 14px 16px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; }
  .table-toolbar h3 { font-size: 0.95rem; font-weight: 700; }
  .search-box { padding: 6px 12px; border: 1px solid var(--border); border-radius: 6px; font-size: 0.84rem; width: 220px; outline: none; }
  .search-box:focus { border-color: var(--orange); }
  .tbl-scroll { overflow-x: auto; }
  table { width: 100%; border-collapse: collapse; font-size: 0.84rem; }
  thead th { background: var(--orange); color: #fff; padding: 10px 12px; text-align: left; font-weight: 700; white-space: nowrap; cursor: pointer; user-select: none; }
  thead th:hover { background: var(--orange-dark); }
  thead th .sort-icon { display: inline-block; margin-left: 4px; opacity: 0.7; font-size: 0.75rem; }
  thead th.sort-asc .sort-icon::after { content: ' ▲'; }
  thead th.sort-desc .sort-icon::after { content: ' ▼'; }
  thead th:not(.sort-asc):not(.sort-desc) .sort-icon::after { content: ' ⇅'; }
  tbody tr:nth-child(even) { background: var(--row-alt); }
  tbody tr:hover { background: #fdecd8; }
  td { padding: 9px 12px; border-bottom: 1px solid var(--border); white-space: nowrap; }
  td.text-cell { white-space: normal; min-width: 200px; max-width: 320px; word-break: break-word; }
  .badge { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 0.78rem; font-weight: 700; }
  .badge-green { background: var(--green-bg); color: var(--green); }
  .badge-amber { background: var(--amber-bg); color: var(--amber); }
  .badge-red { background: var(--red-bg); color: var(--red); }
  .row-count { font-size: 0.78rem; color: var(--muted); }
  .pager { padding: 10px 16px; border-top: 1px solid var(--border); display: flex; align-items: center; gap: 8px; }
  .pager button { padding: 4px 10px; border: 1px solid var(--border); background: #fff; cursor: pointer; border-radius: 4px; font-size: 0.82rem; }
  .pager button:hover { background: var(--orange); color: #fff; border-color: var(--orange); }
  .pager button.active { background: var(--orange); color: #fff; border-color: var(--orange); }
  .pager-info { font-size: 0.82rem; color: var(--muted); margin-left: auto; }
  
  .section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: var(--text); }
  .combined-badge { background: #fff3e0; color: var(--amber); border: 1px solid var(--orange-light); padding: 6px 14px; border-radius: 6px; font-size: 0.82rem; font-weight: 600; display: inline-block; margin-bottom: 16px; }
</style>
</head>
<body>

<div class="header">
  <div class="logo">R</div>
  <div>
    <div class="h1" style="font-size:1.3rem;font-weight:700;color:#fff;">Ruminae PPC Dashboard</div>
    <div class="sub" style="font-size:0.82rem;opacity:0.85;color:#fff;">Week 19 &amp; Week 20 · Amazon Advertising</div>
  </div>
</div>

<div class="nav">
  <button class="nav-btn active" onclick="showTab('overview')">📊 Account Overview</button>
  <button class="nav-btn" onclick="showTab('searchterms')">🔍 Search Terms</button>
  <button class="nav-btn" onclick="showTab('targeting')">🎯 Targeting</button>
  <button class="nav-btn" onclick="showTab('business')">📦 Business Report</button>
  <button class="nav-btn" onclick="showTab('products')">🏷️ Product Tab</button>
  <button class="nav-btn" onclick="showTab('campaigns')">📣 Campaigns</button>
</div>

<!-- ═══════════════════ ACCOUNT OVERVIEW ═══════════════════ -->
<div id="tab-overview" class="section active">
  <div class="section-title">Account Overview — W19 vs W20 Comparison</div>
  
  <div class="overview-grid">
    <div class="week-block">
      <h3>📅 Week 19 — PPC Performance</h3>
      <div class="kpi-row"><span class="kpi-label">Total Ad Spend</span><span class="kpi-val">£742.00</span></div>
      <div class="kpi-row"><span class="kpi-label">PPC Sales</span><span class="kpi-val">£905.00</span></div>
      <div class="kpi-row"><span class="kpi-label">ACOS</span><span class="kpi-val">82.0%</span></div>
      <div class="kpi-row"><span class="kpi-label">ROAS</span><span class="kpi-val">1.22</span></div>
      <div class="kpi-row"><span class="kpi-label">Clicks</span><span class="kpi-val">500</span></div>
      <div class="kpi-row"><span class="kpi-label">CPC</span><span class="kpi-val">£1.48</span></div>
      <div class="kpi-row"><span class="kpi-label">CTR</span><span class="kpi-val">0.33%</span></div>
      <div class="kpi-row"><span class="kpi-label">PPC Orders</span><span class="kpi-val">49</span></div>
      <div class="kpi-row"><span class="kpi-label">CVR</span><span class="kpi-val">9.8%</span></div>
      <div class="kpi-row"><span class="kpi-label">Impressions</span><span class="kpi-val">151,515</span></div>
    </div>
    <div class="week-block">
      <h3>📅 Week 20 — PPC Performance</h3>
      <div class="kpi-row"><span class="kpi-label">Total Ad Spend</span><span class="kpi-val">£630.00</span></div>
      <div class="kpi-row"><span class="kpi-label">PPC Sales</span><span class="kpi-val">£695.00</span></div>
      <div class="kpi-row"><span class="kpi-label">ACOS</span><span class="kpi-val">90.6%</span></div>
      <div class="kpi-row"><span class="kpi-label">ROAS</span><span class="kpi-val">1.10</span></div>
      <div class="kpi-row"><span class="kpi-label">Clicks</span><span class="kpi-val">445</span></div>
      <div class="kpi-row"><span class="kpi-label">CPC</span><span class="kpi-val">£1.42</span></div>
      <div class="kpi-row"><span class="kpi-label">CTR</span><span class="kpi-val">0.20%</span></div>
      <div class="kpi-row"><span class="kpi-label">PPC Orders</span><span class="kpi-val">37</span></div>
      <div class="kpi-row"><span class="kpi-label">CVR</span><span class="kpi-val">8.3%</span></div>
      <div class="kpi-row"><span class="kpi-label">Impressions</span><span class="kpi-val">222,500</span></div>
    </div>
  </div>
  
  <div class="overview-grid">
    <div class="week-block">
      <h3>🛒 Week 19 — Business Totals</h3>
      <div class="kpi-row"><span class="kpi-label">Total Sales</span><span class="kpi-val">£2,154.94</span></div>
      <div class="kpi-row"><span class="kpi-label">Total Orders</span><span class="kpi-val">116</span></div>
      <div class="kpi-row"><span class="kpi-label">Total Units</span><span class="kpi-val">118</span></div>
      <div class="kpi-row"><span class="kpi-label">TACOS</span><span class="kpi-val">34.4%</span></div>
    </div>
    <div class="week-block">
      <h3>🛒 Week 20 — Business Totals</h3>
      <div class="kpi-row"><span class="kpi-label">Total Sales</span><span class="kpi-val">£2,272.83</span></div>
      <div class="kpi-row"><span class="kpi-label">Total Orders</span><span class="kpi-val">118</span></div>
      <div class="kpi-row"><span class="kpi-label">Total Units</span><span class="kpi-val">119</span></div>
      <div class="kpi-row"><span class="kpi-label">TACOS</span><span class="kpi-val">27.7%</span></div>
    </div>
  </div>
  
  <div class="charts-grid">
    <div class="chart-card"><h4>Spend vs Sales</h4><canvas id="c-spend-sales"></canvas></div>
    <div class="chart-card"><h4>ACOS %</h4><canvas id="c-acos"></canvas></div>
    <div class="chart-card"><h4>Orders</h4><canvas id="c-orders"></canvas></div>
    <div class="chart-card"><h4>CPC &amp; CVR</h4><canvas id="c-cpc-cvr"></canvas></div>
  </div>
</div>

<!-- ═══════════════════ SEARCH TERMS ═══════════════════ -->
<div id="tab-searchterms" class="section">
  <div class="combined-badge">📅 Combined W19 + W20 Totals (2-Week Summary)</div>
  <div class="table-wrap">
    <div class="table-toolbar">
      <h3>Search Terms Report <span class="row-count" id="st-count"></span></h3>
      <input class="search-box" id="st-search" placeholder="🔍 Filter search terms…" oninput="filterTable('st')">
    </div>
    <div class="tbl-scroll">
      <table id="tbl-st">
        <thead>
          <tr>
            <th onclick="sortTable('st',0)" data-col="0">Search Term<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',1)" data-col="1">Sales (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',2)" data-col="2">Spend (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',3)" data-col="3">ACOS %<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',4)" data-col="4">ROAS<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',5)" data-col="5">Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',6)" data-col="6">Clicks<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',7)" data-col="7">CVR %<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',8)" data-col="8">Impressions<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',9)" data-col="9">CPC (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('st',10)" data-col="10">CTR %<span class="sort-icon"></span></th>
          </tr>
        </thead>
        <tbody id="tbody-st"></tbody>
      </table>
    </div>
    <div class="pager" id="pager-st"></div>
  </div>
</div>

<!-- ═══════════════════ TARGETING ═══════════════════ -->
<div id="tab-targeting" class="section">
  <div class="combined-badge">📅 Combined W19 + W20 Totals (2-Week Summary)</div>
  <div class="table-wrap">
    <div class="table-toolbar">
      <h3>Targeting Report <span class="row-count" id="tgt-count"></span></h3>
      <input class="search-box" id="tgt-search" placeholder="🔍 Filter targets…" oninput="filterTable('tgt')">
    </div>
    <div class="tbl-scroll">
      <table id="tbl-tgt">
        <thead>
          <tr>
            <th onclick="sortTable('tgt',0)" data-col="0">Target<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',1)" data-col="1">Campaign<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',2)" data-col="2">Sales (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',3)" data-col="3">Spend (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',4)" data-col="4">ACOS %<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',5)" data-col="5">ROAS<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',6)" data-col="6">Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',7)" data-col="7">Clicks<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',8)" data-col="8">CVR %<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',9)" data-col="9">Impressions<span class="sort-icon"></span></th>
            <th onclick="sortTable('tgt',10)" data-col="10">CPC (£)<span class="sort-icon"></span></th>
          </tr>
        </thead>
        <tbody id="tbody-tgt"></tbody>
      </table>
    </div>
    <div class="pager" id="pager-tgt"></div>
  </div>
</div>

<!-- ═══════════════════ BUSINESS REPORT ═══════════════════ -->
<div id="tab-business" class="section">
  <div class="combined-badge">📅 Combined W19 + W20 Totals (2-Week Summary)</div>
  <div class="table-wrap">
    <div class="table-toolbar">
      <h3>Business Report — ASIN Level <span class="row-count" id="biz-count"></span></h3>
      <input class="search-box" id="biz-search" placeholder="🔍 Filter ASINs…" oninput="filterTable('biz')">
    </div>
    <div class="tbl-scroll">
      <table id="tbl-biz">
        <thead>
          <tr>
            <th onclick="sortTable('biz',0)" data-col="0">ASIN<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',1)" data-col="1">Product Title<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',2)" data-col="2">Total Sales (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',3)" data-col="3">Total Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',4)" data-col="4">Units Sold<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',5)" data-col="5">Sessions<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',6)" data-col="6">PPC Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',7)" data-col="7">Organic Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('biz',8)" data-col="8">Organic %<span class="sort-icon"></span></th>
          </tr>
        </thead>
        <tbody id="tbody-biz"></tbody>
      </table>
    </div>
    <div class="pager" id="pager-biz"></div>
  </div>
</div>

<!-- ═══════════════════ PRODUCTS ═══════════════════ -->
<div id="tab-products" class="section">
  <div class="combined-badge">📅 Combined W19 + W20 Totals (2-Week Summary)</div>
  <div class="table-wrap">
    <div class="table-toolbar">
      <h3>Product Tab Report <span class="row-count" id="prod-count"></span></h3>
      <input class="search-box" id="prod-search" placeholder="🔍 Filter products…" oninput="filterTable('prod')">
    </div>
    <div class="tbl-scroll">
      <table id="tbl-prod">
        <thead>
          <tr>
            <th onclick="sortTable('prod',0)" data-col="0">Product / SKU<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',1)" data-col="1">Sales (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',2)" data-col="2">Spend (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',3)" data-col="3">ACOS %<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',4)" data-col="4">ROAS<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',5)" data-col="5">Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',6)" data-col="6">Clicks<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',7)" data-col="7">CVR %<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',8)" data-col="8">Impressions<span class="sort-icon"></span></th>
            <th onclick="sortTable('prod',9)" data-col="9">CPC (£)<span class="sort-icon"></span></th>
          </tr>
        </thead>
        <tbody id="tbody-prod"></tbody>
      </table>
    </div>
    <div class="pager" id="pager-prod"></div>
  </div>
</div>

<!-- ═══════════════════ CAMPAIGNS ═══════════════════ -->
<div id="tab-campaigns" class="section">
  <div class="combined-badge">📅 Combined W19 + W20 Totals (2-Week Summary)</div>
  <div class="table-wrap">
    <div class="table-toolbar">
      <h3>Campaign Level Report <span class="row-count" id="camp-count"></span></h3>
      <input class="search-box" id="camp-search" placeholder="🔍 Filter campaigns…" oninput="filterTable('camp')">
    </div>
    <div class="tbl-scroll">
      <table id="tbl-camp">
        <thead>
          <tr>
            <th onclick="sortTable('camp',0)" data-col="0">Campaign<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',1)" data-col="1">Sales (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',2)" data-col="2">Spend (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',3)" data-col="3">ACOS %<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',4)" data-col="4">ROAS<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',5)" data-col="5">Orders<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',6)" data-col="6">Clicks<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',7)" data-col="7">CVR %<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',8)" data-col="8">Impressions<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',9)" data-col="9">CPC (£)<span class="sort-icon"></span></th>
            <th onclick="sortTable('camp',10)" data-col="10">CTR %<span class="sort-icon"></span></th>
          </tr>
        </thead>
        <tbody id="tbody-camp"></tbody>
      </table>
    </div>
    <div class="pager" id="pager-camp"></div>
  </div>
</div>

<script>
// ─── DATA ──────────────────────────────────────────────────────────────────
const ST_DATA   = [{"term": "eyelash serum", "spend": 149.55, "sales": 167.91, "clicks": 82, "impr": 17177, "orders": 10, "cpc": 1.82, "acos": 89.1, "cvr": 12.2, "ctr": 0.48, "roas": 1.12}, {"term": "eyelash growth serum", "spend": 79.03, "sales": 71.96, "clicks": 57, "impr": 23838, "orders": 4, "cpc": 1.39, "acos": 109.8, "cvr": 7.0, "ctr": 0.24, "roas": 0.91}, {"term": "prostaglandin free eyelash serum", "spend": 45.6, "sales": 17.99, "clicks": 24, "impr": 9499, "orders": 1, "cpc": 1.9, "acos": 253.5, "cvr": 4.2, "ctr": 0.25, "roas": 0.39}, {"term": "lash serum for eyelash growth", "spend": 33.89, "sales": 35.98, "clicks": 23, "impr": 5373, "orders": 2, "cpc": 1.47, "acos": 94.2, "cvr": 8.7, "ctr": 0.43, "roas": 1.06}, {"term": "ruminae eyelash serum", "spend": 29.14, "sales": 53.97, "clicks": 13, "impr": 1093, "orders": 3, "cpc": 2.24, "acos": 54.0, "cvr": 23.1, "ctr": 1.19, "roas": 1.85}, {"term": "b081w78jdn", "spend": 26.86, "sales": 35.98, "clicks": 14, "impr": 2240, "orders": 2, "cpc": 1.92, "acos": 74.7, "cvr": 14.3, "ctr": 0.62, "roas": 1.34}, {"term": "b082wztjv5", "spend": 24.18, "sales": 23.99, "clicks": 15, "impr": 2659, "orders": 1, "cpc": 1.61, "acos": 100.8, "cvr": 6.7, "ctr": 0.56, "roas": 0.99}, {"term": "terez and honor eyelash growth serum", "spend": 23.14, "sales": 17.99, "clicks": 13, "impr": 2761, "orders": 1, "cpc": 1.78, "acos": 128.6, "cvr": 7.7, "ctr": 0.47, "roas": 0.78}, {"term": "korean eyelash growth serum", "spend": 15.58, "sales": 0.0, "clicks": 9, "impr": 1220, "orders": 0, "cpc": 1.73, "acos": 0, "cvr": 0.0, "ctr": 0.74, "roas": 0.0}, {"term": "lash serum for eyelash growth without prostaglandin", "spend": 14.61, "sales": 0.0, "clicks": 7, "impr": 3772, "orders": 0, "cpc": 2.09, "acos": 0, "cvr": 0.0, "ctr": 0.19, "roas": 0.0}, {"term": "b0fxydh4xm", "spend": 14.52, "sales": 0.0, "clicks": 11, "impr": 1002, "orders": 0, "cpc": 1.32, "acos": 0, "cvr": 0.0, "ctr": 1.1, "roas": 0.0}, {"term": "b0g5bhbyfl", "spend": 14.52, "sales": 0.0, "clicks": 6, "impr": 774, "orders": 0, "cpc": 2.42, "acos": 0, "cvr": 0.0, "ctr": 0.78, "roas": 0.0}, {"term": "lash serum korean", "spend": 13.42, "sales": 0.0, "clicks": 7, "impr": 1910, "orders": 0, "cpc": 1.92, "acos": 0, "cvr": 0.0, "ctr": 0.37, "roas": 0.0}, {"term": "lash conditioner after lash lift", "spend": 12.13, "sales": 17.99, "clicks": 6, "impr": 262, "orders": 1, "cpc": 2.02, "acos": 67.4, "cvr": 16.7, "ctr": 2.29, "roas": 1.48}, {"term": "korean lash serum", "spend": 10.73, "sales": 0.0, "clicks": 7, "impr": 734, "orders": 0, "cpc": 1.53, "acos": 0, "cvr": 0.0, "ctr": 0.95, "roas": 0.0}, {"term": "korean eyelash serum", "spend": 10.48, "sales": 0.0, "clicks": 5, "impr": 753, "orders": 0, "cpc": 2.1, "acos": 0, "cvr": 0.0, "ctr": 0.66, "roas": 0.0}, {"term": "lash serum", "spend": 10.2, "sales": 17.99, "clicks": 5, "impr": 920, "orders": 1, "cpc": 2.04, "acos": 56.7, "cvr": 20.0, "ctr": 0.54, "roas": 1.76}, {"term": "lash clusters", "spend": 9.95, "sales": 0.0, "clicks": 5, "impr": 28668, "orders": 0, "cpc": 1.99, "acos": 0, "cvr": 0.0, "ctr": 0.02, "roas": 0.0}, {"term": "scorolash eyelash growth serum", "spend": 9.72, "sales": 17.99, "clicks": 5, "impr": 228, "orders": 1, "cpc": 1.94, "acos": 54.0, "cvr": 20.0, "ctr": 2.19, "roas": 1.85}, {"term": "nuna eyelash growth serum", "spend": 9.72, "sales": 17.99, "clicks": 5, "impr": 1429, "orders": 1, "cpc": 1.94, "acos": 54.0, "cvr": 20.0, "ctr": 0.35, "roas": 1.85}, {"term": "keratin lash serum", "spend": 9.31, "sales": 23.99, "clicks": 5, "impr": 297, "orders": 1, "cpc": 1.86, "acos": 38.8, "cvr": 20.0, "ctr": 1.68, "roas": 2.58}, {"term": "eyelashes serum", "spend": 8.78, "sales": 35.98, "clicks": 5, "impr": 145, "orders": 2, "cpc": 1.76, "acos": 24.4, "cvr": 40.0, "ctr": 3.45, "roas": 4.1}, {"term": "eye lash serum growth", "spend": 8.71, "sales": 17.99, "clicks": 6, "impr": 4533, "orders": 1, "cpc": 1.45, "acos": 48.4, "cvr": 16.7, "ctr": 0.13, "roas": 2.07}, {"term": "rapid lash eyelash growth serum", "spend": 8.01, "sales": 0.0, "clicks": 3, "impr": 260, "orders": 0, "cpc": 2.67, "acos": 0, "cvr": 0.0, "ctr": 1.15, "roas": 0.0}, {"term": "eyebrow and eyelash growth serum", "spend": 7.46, "sales": 0.0, "clicks": 4, "impr": 100, "orders": 0, "cpc": 1.86, "acos": 0, "cvr": 0.0, "ctr": 4.0, "roas": 0.0}, {"term": "babe lash eyelash serum", "spend": 7.29, "sales": 17.99, "clicks": 3, "impr": 120, "orders": 1, "cpc": 2.43, "acos": 40.5, "cvr": 33.3, "ctr": 2.5, "roas": 2.47}, {"term": "korean lash serum for eyelash growth", "spend": 7.09, "sales": 0.0, "clicks": 4, "impr": 25, "orders": 0, "cpc": 1.77, "acos": 0, "cvr": 0.0, "ctr": 16.0, "roas": 0.0}, {"term": "b0fbt1bv4n", "spend": 6.94, "sales": 0.0, "clicks": 6, "impr": 483, "orders": 0, "cpc": 1.16, "acos": 0, "cvr": 0.0, "ctr": 1.24, "roas": 0.0}, {"term": "eyelash growth", "spend": 6.64, "sales": 17.99, "clicks": 4, "impr": 596, "orders": 1, "cpc": 1.66, "acos": 36.9, "cvr": 25.0, "ctr": 0.67, "roas": 2.71}, {"term": "ruminae", "spend": 6.58, "sales": 35.98, "clicks": 13, "impr": 46, "orders": 2, "cpc": 0.51, "acos": 18.3, "cvr": 15.4, "ctr": 28.26, "roas": 5.47}, {"term": "obagi eyelash growth serum", "spend": 6.49, "sales": 0.0, "clicks": 4, "impr": 711, "orders": 0, "cpc": 1.62, "acos": 0, "cvr": 0.0, "ctr": 0.56, "roas": 0.0}, {"term": "show lash eyelash growth serum", "spend": 6.47, "sales": 0.0, "clicks": 4, "impr": 202, "orders": 0, "cpc": 1.62, "acos": 0, "cvr": 0.0, "ctr": 1.98, "roas": 0.0}, {"term": "eyebrow serum for growth", "spend": 6.0, "sales": 0.0, "clicks": 3, "impr": 2014, "orders": 0, "cpc": 2.0, "acos": 0, "cvr": 0.0, "ctr": 0.15, "roas": 0.0}, {"term": "lash growth", "spend": 5.4, "sales": 0.0, "clicks": 3, "impr": 48, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 6.25, "roas": 0.0}, {"term": "ruminae power & volume eyelash serum", "spend": 5.37, "sales": 0.0, "clicks": 5, "impr": 10, "orders": 0, "cpc": 1.07, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "eyelashes growth serum", "spend": 5.12, "sales": 17.99, "clicks": 4, "impr": 209, "orders": 1, "cpc": 1.28, "acos": 28.5, "cvr": 25.0, "ctr": 1.91, "roas": 3.51}, {"term": "the ordinary lash curl finisher", "spend": 4.8, "sales": 0.0, "clicks": 3, "impr": 54, "orders": 0, "cpc": 1.6, "acos": 0, "cvr": 0.0, "ctr": 5.56, "roas": 0.0}, {"term": "magnetic eyelashes natural look", "spend": 4.8, "sales": 35.98, "clicks": 3, "impr": 4651, "orders": 2, "cpc": 1.6, "acos": 13.3, "cvr": 66.7, "ctr": 0.06, "roas": 7.5}, {"term": "b018zxeo50", "spend": 4.71, "sales": 17.99, "clicks": 4, "impr": 230, "orders": 1, "cpc": 1.18, "acos": 26.2, "cvr": 25.0, "ctr": 1.74, "roas": 3.82}, {"term": "lash mask", "spend": 4.5, "sales": 0.0, "clicks": 2, "impr": 271, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 0.74, "roas": 0.0}, {"term": "clear mascara with growth serum", "spend": 4.47, "sales": 0.0, "clicks": 3, "impr": 25, "orders": 0, "cpc": 1.49, "acos": 0, "cvr": 0.0, "ctr": 12.0, "roas": 0.0}, {"term": "clear brow gel", "spend": 4.46, "sales": 0.0, "clicks": 2, "impr": 45, "orders": 0, "cpc": 2.23, "acos": 0, "cvr": 0.0, "ctr": 4.44, "roas": 0.0}, {"term": "eyebrow growth serum for women", "spend": 4.35, "sales": 17.99, "clicks": 2, "impr": 35, "orders": 1, "cpc": 2.17, "acos": 24.2, "cvr": 50.0, "ctr": 5.71, "roas": 4.14}, {"term": "eye patches for puffy eyes and dark circles", "spend": 4.33, "sales": 0.0, "clicks": 2, "impr": 171, "orders": 0, "cpc": 2.17, "acos": 0, "cvr": 0.0, "ctr": 1.17, "roas": 0.0}, {"term": "korean lash lift", "spend": 4.14, "sales": 0.0, "clicks": 2, "impr": 164, "orders": 0, "cpc": 2.07, "acos": 0, "cvr": 0.0, "ctr": 1.22, "roas": 0.0}, {"term": "viebeauti eyelash growth serum", "spend": 3.89, "sales": 0.0, "clicks": 2, "impr": 56, "orders": 0, "cpc": 1.95, "acos": 0, "cvr": 0.0, "ctr": 3.57, "roas": 0.0}, {"term": "safe eyelash growth serum", "spend": 3.87, "sales": 17.99, "clicks": 2, "impr": 416, "orders": 1, "cpc": 1.94, "acos": 21.5, "cvr": 50.0, "ctr": 0.48, "roas": 4.65}, {"term": "etude curl fix", "spend": 3.8, "sales": 0.0, "clicks": 3, "impr": 290, "orders": 0, "cpc": 1.27, "acos": 0, "cvr": 0.0, "ctr": 1.03, "roas": 0.0}, {"term": "organic eyelash growth serum", "spend": 3.79, "sales": 17.99, "clicks": 2, "impr": 26, "orders": 1, "cpc": 1.9, "acos": 21.1, "cvr": 50.0, "ctr": 7.69, "roas": 4.75}, {"term": "peptide eyelash growth serum", "spend": 3.79, "sales": 0.0, "clicks": 2, "impr": 10, "orders": 0, "cpc": 1.9, "acos": 0, "cvr": 0.0, "ctr": 20.0, "roas": 0.0}, {"term": "nulastin eyelash growth serum", "spend": 3.79, "sales": 0.0, "clicks": 2, "impr": 22, "orders": 0, "cpc": 1.9, "acos": 0, "cvr": 0.0, "ctr": 9.09, "roas": 0.0}, {"term": "cosnori eyelash growth serum", "spend": 3.79, "sales": 0.0, "clicks": 2, "impr": 1126, "orders": 0, "cpc": 1.9, "acos": 0, "cvr": 0.0, "ctr": 0.18, "roas": 0.0}, {"term": "sweed eyelash growth serum", "spend": 3.79, "sales": 0.0, "clicks": 2, "impr": 112, "orders": 0, "cpc": 1.9, "acos": 0, "cvr": 0.0, "ctr": 1.79, "roas": 0.0}, {"term": "eyebrow serum", "spend": 3.73, "sales": 0.0, "clicks": 3, "impr": 75, "orders": 0, "cpc": 1.24, "acos": 0, "cvr": 0.0, "ctr": 4.0, "roas": 0.0}, {"term": "eyelash growth serum maree", "spend": 3.68, "sales": 0.0, "clicks": 2, "impr": 51, "orders": 0, "cpc": 1.84, "acos": 0, "cvr": 0.0, "ctr": 3.92, "roas": 0.0}, {"term": "eyelash growth mascara", "spend": 3.66, "sales": 17.99, "clicks": 3, "impr": 341, "orders": 1, "cpc": 1.22, "acos": 20.3, "cvr": 33.3, "ctr": 0.88, "roas": 4.92}, {"term": "eyelash growth serum prostaglandin free", "spend": 3.61, "sales": 0.0, "clicks": 2, "impr": 9, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 22.22, "roas": 0.0}, {"term": "lash growth serum", "spend": 3.6, "sales": 0.0, "clicks": 2, "impr": 111, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 1.8, "roas": 0.0}, {"term": "maree eyelash serum", "spend": 3.45, "sales": 0.0, "clicks": 2, "impr": 41, "orders": 0, "cpc": 1.73, "acos": 0, "cvr": 0.0, "ctr": 4.88, "roas": 0.0}, {"term": "eyelash growth serum no prostaglandin", "spend": 3.45, "sales": 0.0, "clicks": 2, "impr": 13, "orders": 0, "cpc": 1.73, "acos": 0, "cvr": 0.0, "ctr": 15.38, "roas": 0.0}, {"term": "lash serum forchics", "spend": 3.42, "sales": 0.0, "clicks": 2, "impr": 19, "orders": 0, "cpc": 1.71, "acos": 0, "cvr": 0.0, "ctr": 10.53, "roas": 0.0}, {"term": "rapidlash eyelash growth serum", "spend": 3.3, "sales": 0.0, "clicks": 2, "impr": 223, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 0.9, "roas": 0.0}, {"term": "serum for eyelash growth", "spend": 3.3, "sales": 17.99, "clicks": 2, "impr": 25, "orders": 1, "cpc": 1.65, "acos": 18.3, "cvr": 50.0, "ctr": 8.0, "roas": 5.45}, {"term": "lash growth serum top rated", "spend": 3.28, "sales": 0.0, "clicks": 3, "impr": 120, "orders": 0, "cpc": 1.09, "acos": 0, "cvr": 0.0, "ctr": 2.5, "roas": 0.0}, {"term": "5 star eyelash growth serum", "spend": 3.27, "sales": 0.0, "clicks": 2, "impr": 527, "orders": 0, "cpc": 1.64, "acos": 0, "cvr": 0.0, "ctr": 0.38, "roas": 0.0}, {"term": "korean eyelashes", "spend": 3.24, "sales": 0.0, "clicks": 2, "impr": 5, "orders": 0, "cpc": 1.62, "acos": 0, "cvr": 0.0, "ctr": 40.0, "roas": 0.0}, {"term": "nourishing lash serum after lash lift", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "eye lash growing serum peptides", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash keratin conditioner", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "eyelash conditioner and growth serum", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 5, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 20.0, "roas": 0.0}, {"term": "moxie lash", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "eyebrow growth serum", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 117, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 0.85, "roas": 0.0}, {"term": "babe eyelash growth serum", "spend": 3.15, "sales": 17.99, "clicks": 1, "impr": 1, "orders": 1, "cpc": 3.15, "acos": 17.5, "cvr": 100.0, "ctr": 100.0, "roas": 5.71}, {"term": "lash growth serum best seller", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "lash growth serum for lungs", "spend": 3.15, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 3.15, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "highest rated eyelash growth serum", "spend": 3.15, "sales": 17.99, "clicks": 1, "impr": 2, "orders": 1, "cpc": 3.15, "acos": 17.5, "cvr": 100.0, "ctr": 50.0, "roas": 5.71}, {"term": "korean eyelash serum for growth", "spend": 3.13, "sales": 17.99, "clicks": 1, "impr": 2, "orders": 1, "cpc": 3.13, "acos": 17.4, "cvr": 100.0, "ctr": 50.0, "roas": 5.75}, {"term": "eyelash growth serum viebeauti", "spend": 3.11, "sales": 0.0, "clicks": 2, "impr": 1104, "orders": 0, "cpc": 1.55, "acos": 0, "cvr": 0.0, "ctr": 0.18, "roas": 0.0}, {"term": "eyebrow thickener serum", "spend": 3.08, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 3.08, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "gentle eyelash growth serum", "spend": 2.97, "sales": 17.99, "clicks": 1, "impr": 1, "orders": 1, "cpc": 2.97, "acos": 16.5, "cvr": 100.0, "ctr": 100.0, "roas": 6.06}, {"term": "asian makeup products", "spend": 2.92, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.92, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "vegan eyelash growth serum", "spend": 2.91, "sales": 0.0, "clicks": 2, "impr": 146, "orders": 0, "cpc": 1.46, "acos": 0, "cvr": 0.0, "ctr": 1.37, "roas": 0.0}, {"term": "keratin boost for lashes", "spend": 2.88, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.88, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "anastasia brow", "spend": 2.85, "sales": 0.0, "clicks": 2, "impr": 804, "orders": 0, "cpc": 1.43, "acos": 0, "cvr": 0.0, "ctr": 0.25, "roas": 0.0}, {"term": "pumpkin seed oil lash serum", "spend": 2.79, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.79, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash primer", "spend": 2.77, "sales": 0.0, "clicks": 2, "impr": 32, "orders": 0, "cpc": 1.39, "acos": 0, "cvr": 0.0, "ctr": 6.25, "roas": 0.0}, {"term": "brow conditioner after lamination", "spend": 2.7, "sales": 0.0, "clicks": 2, "impr": 2, "orders": 0, "cpc": 1.35, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "serum eyelashes ruminae", "spend": 2.66, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.66, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "protein bombeyelash serum", "spend": 2.59, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.59, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash serum prostaglandin free", "spend": 2.55, "sales": 0.0, "clicks": 2, "impr": 34, "orders": 0, "cpc": 1.27, "acos": 0, "cvr": 0.0, "ctr": 5.88, "roas": 0.0}, {"term": "korean lash lift kit", "spend": 2.53, "sales": 0.0, "clicks": 2, "impr": 38, "orders": 0, "cpc": 1.26, "acos": 0, "cvr": 0.0, "ctr": 5.26, "roas": 0.0}, {"term": "eight saints", "spend": 2.51, "sales": 0.0, "clicks": 1, "impr": 7, "orders": 0, "cpc": 2.51, "acos": 0, "cvr": 0.0, "ctr": 14.29, "roas": 0.0}, {"term": "lash and brow serum", "spend": 2.51, "sales": 0.0, "clicks": 2, "impr": 8, "orders": 0, "cpc": 1.25, "acos": 0, "cvr": 0.0, "ctr": 25.0, "roas": 0.0}, {"term": "ruminae mascara", "spend": 2.48, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 2.48, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "brow growth serum look for peptides, biotin\u2014not lash serums", "spend": 2.46, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.46, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "etude eyelash growth serum", "spend": 2.4, "sales": 0.0, "clicks": 2, "impr": 206, "orders": 0, "cpc": 1.2, "acos": 0, "cvr": 0.0, "ctr": 0.97, "roas": 0.0}, {"term": "b0gs23g6bg", "spend": 2.4, "sales": 0.0, "clicks": 2, "impr": 96, "orders": 0, "cpc": 1.2, "acos": 0, "cvr": 0.0, "ctr": 2.08, "roas": 0.0}, {"term": "eyelash growth serum without prostaglandin", "spend": 2.37, "sales": 0.0, "clicks": 2, "impr": 111, "orders": 0, "cpc": 1.19, "acos": 0, "cvr": 0.0, "ctr": 1.8, "roas": 0.0}, {"term": "ruminae korean retinol", "spend": 2.34, "sales": 0.0, "clicks": 1, "impr": 71, "orders": 0, "cpc": 2.34, "acos": 0, "cvr": 0.0, "ctr": 1.41, "roas": 0.0}, {"term": "eyebrow lamination gel", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 112, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 0.89, "roas": 0.0}, {"term": "alice lash cluster", "spend": 2.25, "sales": 17.99, "clicks": 1, "impr": 29, "orders": 1, "cpc": 2.25, "acos": 12.5, "cvr": 100.0, "ctr": 3.45, "roas": 8.0}, {"term": "n-acetyl glucosamine cosmetic", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "sown lash serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 4, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 25.0, "roas": 0.0}, {"term": "eyelash serum sensitive eyes", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 58, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 1.72, "roas": 0.0}, {"term": "brow regrowth serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash princess serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "minoxidil for eyebrow growth", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "sensitive eyelash serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash buddy self-adhesive eyelashes", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "best lash serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "eyelashes natural look", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 421, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 0.24, "roas": 0.0}, {"term": "lash growth serum peptide natural", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "eye brow and lash serum", "spend": 2.25, "sales": 17.99, "clicks": 1, "impr": 2, "orders": 1, "cpc": 2.25, "acos": 12.5, "cvr": 100.0, "ctr": 50.0, "roas": 8.0}, {"term": "korean lash and brow serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eye and brow serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 13, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 7.69, "roas": 0.0}, {"term": "revitabrow", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "glueless lash lift shields", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 45, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 2.22, "roas": 0.0}, {"term": "brow and lash growth serum", "spend": 2.25, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 2.25, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "refilled eyelash serum", "spend": 2.25, "sales": 0.0, "clicks": 2, "impr": 5, "orders": 0, "cpc": 1.12, "acos": 0, "cvr": 0.0, "ctr": 40.0, "roas": 0.0}, {"term": "ruminae korean eyelash growth serum", "spend": 2.22, "sales": 53.97, "clicks": 2, "impr": 3, "orders": 2, "cpc": 1.11, "acos": 4.1, "cvr": 100.0, "ctr": 66.67, "roas": 24.31}, {"term": "\ufffcprimer moisturizer for lashes", "spend": 2.2, "sales": 17.99, "clicks": 1, "impr": 1, "orders": 1, "cpc": 2.2, "acos": 12.2, "cvr": 100.0, "ctr": 100.0, "roas": 8.18}, {"term": "lash tape", "spend": 2.2, "sales": 0.0, "clicks": 1, "impr": 64, "orders": 0, "cpc": 2.2, "acos": 0, "cvr": 0.0, "ctr": 1.56, "roas": 0.0}, {"term": "selvian for eyebrow and eyelash growth", "spend": 2.16, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 2.16, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "serum for eyelashes growth hidralash", "spend": 2.16, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.16, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "brow growth serum", "spend": 2.15, "sales": 0.0, "clicks": 1, "impr": 14, "orders": 0, "cpc": 2.15, "acos": 0, "cvr": 0.0, "ctr": 7.14, "roas": 0.0}, {"term": "eyelash growth serum elf", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 116, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 0.86, "roas": 0.0}, {"term": "eyelash growth serum safe for lash extensions", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "ash serum for eyelash growth", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 848, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 0.12, "roas": 0.0}, {"term": "lilash eyelash growth serum", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 29, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 3.45, "roas": 0.0}, {"term": "recuren plus eyelash growth serum", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 35, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 2.86, "roas": 0.0}, {"term": "talika eyelash growth serum", "spend": 2.14, "sales": 17.99, "clicks": 1, "impr": 4, "orders": 1, "cpc": 2.14, "acos": 11.9, "cvr": 100.0, "ctr": 25.0, "roas": 8.41}, {"term": "uklash eyelash growth serum", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 181, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 0.55, "roas": 0.0}, {"term": "toplash eyelash growth serum", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 26, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 3.85, "roas": 0.0}, {"term": "revitalash eyelash growth serum", "spend": 2.14, "sales": 17.99, "clicks": 1, "impr": 146, "orders": 1, "cpc": 2.14, "acos": 11.9, "cvr": 100.0, "ctr": 0.68, "roas": 8.41}, {"term": "eyelash growth silver", "spend": 2.14, "sales": 0.0, "clicks": 1, "impr": 6, "orders": 0, "cpc": 2.14, "acos": 0, "cvr": 0.0, "ctr": 16.67, "roas": 0.0}, {"term": "mascara for eyelashes for growth", "spend": 2.12, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.12, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "the ordinary brow serum", "spend": 2.12, "sales": 0.0, "clicks": 1, "impr": 58, "orders": 0, "cpc": 2.12, "acos": 0, "cvr": 0.0, "ctr": 1.72, "roas": 0.0}, {"term": "keratin lash conditioning serum", "spend": 2.11, "sales": 23.99, "clicks": 1, "impr": 1, "orders": 1, "cpc": 2.11, "acos": 8.8, "cvr": 100.0, "ctr": 100.0, "roas": 11.37}, {"term": "keratin lash lift serum", "spend": 2.11, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.11, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "sace lady lasting waterproof", "spend": 2.09, "sales": 0.0, "clicks": 1, "impr": 6, "orders": 0, "cpc": 2.09, "acos": 0, "cvr": 0.0, "ctr": 16.67, "roas": 0.0}, {"term": "instant brow fix", "spend": 2.08, "sales": 0.0, "clicks": 1, "impr": 9, "orders": 0, "cpc": 2.08, "acos": 0, "cvr": 0.0, "ctr": 11.11, "roas": 0.0}, {"term": "see through eyelash growth serum", "spend": 2.07, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 2.07, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "keratin lash perm", "spend": 2.06, "sales": 0.0, "clicks": 1, "impr": 15, "orders": 0, "cpc": 2.06, "acos": 0, "cvr": 0.0, "ctr": 6.67, "roas": 0.0}, {"term": "inkey", "spend": 2.04, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 2.04, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash serum organic", "spend": 2.03, "sales": 0.0, "clicks": 1, "impr": 4, "orders": 0, "cpc": 2.03, "acos": 0, "cvr": 0.0, "ctr": 25.0, "roas": 0.0}, {"term": "lash conditioner", "spend": 2.02, "sales": 0.0, "clicks": 2, "impr": 26, "orders": 0, "cpc": 1.01, "acos": 0, "cvr": 0.0, "ctr": 7.69, "roas": 0.0}, {"term": "lash thickening serum", "spend": 2.0, "sales": 0.0, "clicks": 1, "impr": 26, "orders": 0, "cpc": 2.0, "acos": 0, "cvr": 0.0, "ctr": 3.85, "roas": 0.0}, {"term": "b00gwtqsi6", "spend": 2.0, "sales": 0.0, "clicks": 1, "impr": 46, "orders": 0, "cpc": 2.0, "acos": 0, "cvr": 0.0, "ctr": 2.17, "roas": 0.0}, {"term": "eyelash skincare korean", "spend": 1.98, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 1.98, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "maree eyelash growth serum", "spend": 1.92, "sales": 0.0, "clicks": 1, "impr": 729, "orders": 0, "cpc": 1.92, "acos": 0, "cvr": 0.0, "ctr": 0.14, "roas": 0.0}, {"term": "kiss eyelashes", "spend": 1.92, "sales": 0.0, "clicks": 1, "impr": 185, "orders": 0, "cpc": 1.92, "acos": 0, "cvr": 0.0, "ctr": 0.54, "roas": 0.0}, {"term": "brow and lash conditioning serum", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "pil combo for lash growth", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyelash growth serum with brush", "spend": 1.89, "sales": 17.99, "clicks": 1, "impr": 1, "orders": 1, "cpc": 1.89, "acos": 10.5, "cvr": 100.0, "ctr": 100.0, "roas": 9.52}, {"term": "isopropyl cloprostenate brow", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eye makeup korean", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "power and volume lash serum", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "korean eyelash", "spend": 1.89, "sales": 0.0, "clicks": 1, "impr": 4, "orders": 0, "cpc": 1.89, "acos": 0, "cvr": 0.0, "ctr": 25.0, "roas": 0.0}, {"term": "\ufffceyelash serum", "spend": 1.87, "sales": 0.0, "clicks": 1, "impr": 8, "orders": 0, "cpc": 1.87, "acos": 0, "cvr": 0.0, "ctr": 12.5, "roas": 0.0}, {"term": "lash premier", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 84, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 1.19, "roas": 0.0}, {"term": "nectarine beauty", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "thrive causemetics liquid lash", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 10, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 10.0, "roas": 0.0}, {"term": "lash serum with brush applicator", "spend": 1.8, "sales": 23.99, "clicks": 1, "impr": 3, "orders": 1, "cpc": 1.8, "acos": 7.5, "cvr": 100.0, "ctr": 33.33, "roas": 13.33}, {"term": "eyelash primer for older women", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "natural eyebrow growth serum", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "shiseido eyelash serum", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 8, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 12.5, "roas": 0.0}, {"term": "etude lash primer", "spend": 1.8, "sales": 0.0, "clicks": 1, "impr": 18, "orders": 0, "cpc": 1.8, "acos": 0, "cvr": 0.0, "ctr": 5.56, "roas": 0.0}, {"term": "eyebrows serum growth", "spend": 1.78, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 1.78, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "eyebrow conditioner and growth", "spend": 1.77, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 1.77, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "forchics eyelash serum", "spend": 1.74, "sales": 0.0, "clicks": 2, "impr": 44, "orders": 0, "cpc": 0.87, "acos": 0, "cvr": 0.0, "ctr": 4.55, "roas": 0.0}, {"term": "eye lash conditioner serum", "spend": 1.72, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.72, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "lash growth metal wind mascara feather", "spend": 1.69, "sales": 0.0, "clicks": 1, "impr": 4, "orders": 0, "cpc": 1.69, "acos": 0, "cvr": 0.0, "ctr": 25.0, "roas": 0.0}, {"term": "isopropyl cloprostenate eyelash serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "bloomskin eyebrow serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "swead beauty eyelash serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "for chicks eyelash serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eye brow growing serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "essence lash", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 17, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 5.88, "roas": 0.0}, {"term": "grow lashes serum", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyebrow ampoule", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "black lash serum korean", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyelash separator", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 5, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 20.0, "roas": 0.0}, {"term": "minoxidil foam", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 6, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 16.67, "roas": 0.0}, {"term": "ukalash", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyelash serum applicator", "spend": 1.68, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 1.68, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "dhc eyelash growth serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 123, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 0.81, "roas": 0.0}, {"term": "eyelash growth pencil", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "lattice eyelash growth serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 7, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 14.29, "roas": 0.0}, {"term": "best lash serum for eyelash growth", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 7, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 14.29, "roas": 0.0}, {"term": "eyelash growth serum top rated", "spend": 1.65, "sales": 23.99, "clicks": 1, "impr": 14, "orders": 1, "cpc": 1.65, "acos": 6.9, "cvr": 100.0, "ctr": 7.14, "roas": 14.54}, {"term": "rodan eyelash growth serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyelash growth serum for sensitive eyes", "spend": 1.65, "sales": 23.99, "clicks": 1, "impr": 36, "orders": 1, "cpc": 1.65, "acos": 6.9, "cvr": 100.0, "ctr": 2.78, "roas": 14.54}, {"term": "eyelash growth serum k", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 1, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 100.0, "roas": 0.0}, {"term": "eyelash growth lotion", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 3, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 33.33, "roas": 0.0}, {"term": "epais eyelash growth serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 8, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 12.5, "roas": 0.0}, {"term": "clione prime eyelash growth serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 16, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 6.25, "roas": 0.0}, {"term": "korean eyelash growth lotion", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 2, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 50.0, "roas": 0.0}, {"term": "ordinary eye lash serum", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 9, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 11.11, "roas": 0.0}, {"term": "eyelash growth serum cosnori", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 50, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 2.0, "roas": 0.0}, {"term": "lash serum for eyelash growth prostaglandin free", "spend": 1.65, "sales": 0.0, "clicks": 1, "impr": 9, "orders": 0, "cpc": 1.65, "acos": 0, "cvr": 0.0, "ctr": 11.11, "roas": 0.0}];
const TGT_DATA  = [{"target": "loose-match", "campaign": "SP - Auto - B2B", "spend": 407.04, "sales": 401.78, "clicks": 221, "impr": 161734, "orders": 22, "cpc": 1.84, "acos": 101.3, "cvr": 10.0, "ctr": 0.14, "roas": 0.99}, {"target": "eyelash growth", "campaign": "POWER-SP-PHRASE", "spend": 228.32, "sales": 245.87, "clicks": 132, "impr": 53232, "orders": 13, "cpc": 1.73, "acos": 92.9, "cvr": 9.8, "ctr": 0.25, "roas": 1.08}, {"target": "eyelash serum", "campaign": "POWER-SP-PHRASE", "spend": 169.36, "sales": 239.87, "clicks": 98, "impr": 28501, "orders": 14, "cpc": 1.73, "acos": 70.6, "cvr": 14.3, "ctr": 0.34, "roas": 1.42}, {"target": "price=18.990000-45.990000 category=\"Eyelash Primers\"", "campaign": "SP - CAT", "spend": 67.95, "sales": 41.98, "clicks": 50, "impr": 8806, "orders": 2, "cpc": 1.36, "acos": 161.9, "cvr": 4.0, "ctr": 0.57, "roas": 0.62}, {"target": "eyelash growth serum", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 57.93, "sales": 53.97, "clicks": 47, "impr": 25900, "orders": 3, "cpc": 1.23, "acos": 107.3, "cvr": 6.4, "ctr": 0.18, "roas": 0.93}, {"target": "prostaglandin free eyelash serum", "campaign": "SKC-POWER-prostaglandin free eyelash serum", "spend": 43.35, "sales": 17.99, "clicks": 23, "impr": 11540, "orders": 1, "cpc": 1.88, "acos": 241.0, "cvr": 4.3, "ctr": 0.2, "roas": 0.41}, {"target": "asin=\"B081W78JDN\"", "campaign": "SP - PAT - Nuorganic/Vibeauty/Eight Saints", "spend": 32.72, "sales": 35.98, "clicks": 17, "impr": 2794, "orders": 2, "cpc": 1.92, "acos": 90.9, "cvr": 11.8, "ctr": 0.61, "roas": 1.1}, {"target": "ruminae", "campaign": "Ruminae-Brand Keywords-All Match", "spend": 28.97, "sales": 185.9, "clicks": 34, "impr": 770, "orders": 9, "cpc": 0.85, "acos": 15.6, "cvr": 26.5, "ctr": 4.42, "roas": 6.42}, {"target": "ruminae eyelash serum", "campaign": "Ruminae-Brand Keywords-All Match", "spend": 27.33, "sales": 53.97, "clicks": 12, "impr": 1747, "orders": 3, "cpc": 2.28, "acos": 50.6, "cvr": 25.0, "ctr": 0.69, "roas": 1.97}, {"target": "lash serum for eyelash growth", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 22.85, "sales": 35.98, "clicks": 17, "impr": 8567, "orders": 2, "cpc": 1.34, "acos": 63.5, "cvr": 11.8, "ctr": 0.2, "roas": 1.57}, {"target": "asin=\"B0G5BHBYFL\"", "campaign": "SP - PAT - Nuorganic/Vibeauty/Eight Saints", "spend": 17.03, "sales": 0.0, "clicks": 7, "impr": 1545, "orders": 0, "cpc": 2.43, "acos": 0, "cvr": 0.0, "ctr": 0.45, "roas": 0.0}, {"target": "lash serum for eyelash growth without prostaglandin", "campaign": "POWER-SP-EXACT-5 Support - eyelash serum", "spend": 14.61, "sales": 0.0, "clicks": 7, "impr": 4156, "orders": 0, "cpc": 2.09, "acos": 0, "cvr": 0.0, "ctr": 0.17, "roas": 0.0}, {"target": "keratin lash", "campaign": "Regene-SP-Repair-Keratin Keywords", "spend": 14.35, "sales": 47.98, "clicks": 8, "impr": 1060, "orders": 2, "cpc": 1.79, "acos": 29.9, "cvr": 25.0, "ctr": 0.75, "roas": 3.34}, {"target": "korean lash serum", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 10.73, "sales": 0.0, "clicks": 7, "impr": 1588, "orders": 0, "cpc": 1.53, "acos": 0, "cvr": 0.0, "ctr": 0.44, "roas": 0.0}, {"target": "lash serum korean", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 10.27, "sales": 0.0, "clicks": 6, "impr": 2231, "orders": 0, "cpc": 1.71, "acos": 0, "cvr": 0.0, "ctr": 0.27, "roas": 0.0}, {"target": "lash conditioner", "campaign": "POWER-SP-PHRASE", "spend": 8.16, "sales": 23.99, "clicks": 7, "impr": 641, "orders": 1, "cpc": 1.17, "acos": 34.0, "cvr": 14.3, "ctr": 1.09, "roas": 2.94}, {"target": "eyebrow serum for growth", "campaign": "POWER-SP-EXACT-5 Support - eyelash serum", "spend": 7.78, "sales": 0.0, "clicks": 4, "impr": 2520, "orders": 0, "cpc": 1.95, "acos": 0, "cvr": 0.0, "ctr": 0.16, "roas": 0.0}, {"target": "lash growth", "campaign": "POWER-SP-PHRASE", "spend": 6.54, "sales": 0.0, "clicks": 7, "impr": 1299, "orders": 0, "cpc": 0.93, "acos": 0, "cvr": 0.0, "ctr": 0.54, "roas": 0.0}, {"target": "prostaglandin", "campaign": "POWER-SP-PHRASE", "spend": 6.46, "sales": 0.0, "clicks": 6, "impr": 482, "orders": 0, "cpc": 1.08, "acos": 0, "cvr": 0.0, "ctr": 1.24, "roas": 0.0}, {"target": "eye lash serum growth", "campaign": "SKC-POWER-eye lash serum growth", "spend": 6.0, "sales": 17.99, "clicks": 4, "impr": 5213, "orders": 1, "cpc": 1.5, "acos": 33.4, "cvr": 25.0, "ctr": 0.08, "roas": 3.0}, {"target": "clear mascara with growth serum", "campaign": "SKC-POWER-clear mascara with growth serum", "spend": 4.47, "sales": 0.0, "clicks": 3, "impr": 163, "orders": 0, "cpc": 1.49, "acos": 0, "cvr": 0.0, "ctr": 1.84, "roas": 0.0}, {"target": "korean eyelash growth serum", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 3.84, "sales": 0.0, "clicks": 2, "impr": 620, "orders": 0, "cpc": 1.92, "acos": 0, "cvr": 0.0, "ctr": 0.32, "roas": 0.0}, {"target": "close-match", "campaign": "SP - Auto - B2B", "spend": 3.06, "sales": 0.0, "clicks": 4, "impr": 1085, "orders": 0, "cpc": 0.77, "acos": 0, "cvr": 0.0, "ctr": 0.37, "roas": 0.0}, {"target": "korean lash", "campaign": "POWER-SP-PHRASE", "spend": 2.95, "sales": 0.0, "clicks": 3, "impr": 3436, "orders": 0, "cpc": 0.98, "acos": 0, "cvr": 0.0, "ctr": 0.09, "roas": 0.0}, {"target": "korean eyelash serum", "campaign": "SKC-POWER-korean eyelash serum", "spend": 2.94, "sales": 0.0, "clicks": 2, "impr": 1858, "orders": 0, "cpc": 1.47, "acos": 0, "cvr": 0.0, "ctr": 0.11, "roas": 0.0}, {"target": "substitutes", "campaign": "SP - Auto - B2B", "spend": 2.4, "sales": 0.0, "clicks": 2, "impr": 1798, "orders": 0, "cpc": 1.2, "acos": 0, "cvr": 0.0, "ctr": 0.11, "roas": 0.0}, {"target": "eyelash growth serum without prostaglandin", "campaign": "POWER-SP-EXACT-5 HERO", "spend": 2.37, "sales": 0.0, "clicks": 2, "impr": 394, "orders": 0, "cpc": 1.19, "acos": 0, "cvr": 0.0, "ctr": 0.51, "roas": 0.0}, {"target": "lash thickening serum", "campaign": "SKC-POWER-lash thickening serum", "spend": 2.0, "sales": 0.0, "clicks": 1, "impr": 43, "orders": 0, "cpc": 2.0, "acos": 0, "cvr": 0.0, "ctr": 2.33, "roas": 0.0}, {"target": "korean eyelash", "campaign": "POWER-SP-PHRASE", "spend": 1.63, "sales": 0.0, "clicks": 1, "impr": 544, "orders": 0, "cpc": 1.63, "acos": 0, "cvr": 0.0, "ctr": 0.18, "roas": 0.0}, {"target": "eyelash growth serum mascara", "campaign": "SKC-POWER-eyelash growth serum mascara", "spend": 1.4, "sales": 0.0, "clicks": 1, "impr": 91, "orders": 0, "cpc": 1.4, "acos": 0, "cvr": 0.0, "ctr": 1.1, "roas": 0.0}, {"target": "growth serum mascara", "campaign": "SKC-POWER-growth serum mascara", "spend": 1.4, "sales": 0.0, "clicks": 1, "impr": 19, "orders": 0, "cpc": 1.4, "acos": 0, "cvr": 0.0, "ctr": 5.26, "roas": 0.0}, {"target": "korean brow", "campaign": "POWER-SP-PHRASE", "spend": 1.04, "sales": 0.0, "clicks": 1, "impr": 256, "orders": 0, "cpc": 1.04, "acos": 0, "cvr": 0.0, "ctr": 0.39, "roas": 0.0}, {"target": "eyelash conditioner", "campaign": "POWER-SP-PHRASE", "spend": 0.79, "sales": 0.0, "clicks": 1, "impr": 263, "orders": 0, "cpc": 0.79, "acos": 0, "cvr": 0.0, "ctr": 0.38, "roas": 0.0}, {"target": "eyelash repair serum", "campaign": "Regene-SP-Repair-Keratin Keywords", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 24, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"target": "lash serum without prostaglandin", "campaign": "SP - Exact - B2B - lash serum without prostaglandin", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 141, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"target": "peptide lash", "campaign": "POWER-SP-PHRASE", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 66, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"target": "lash serum for sensitive eyes", "campaign": "SKC-POWER-lash serum for sensitive eyes", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 40, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}];
const CAMP_DATA = [{"campaign": "POWER-SP-AUTO_AUDIENCE", "spend": 409.44, "sales": 401.78, "clicks": 223, "impr": 162621, "orders": 22, "cpc": 1.84, "acos": 101.9, "cvr": 9.9, "ctr": 0.14, "roas": 0.98}, {"campaign": "POWER-SP-PHRASE", "spend": 267.3, "sales": 305.84, "clicks": 169, "impr": 68760, "orders": 16, "cpc": 1.58, "acos": 87.4, "cvr": 9.5, "ctr": 0.25, "roas": 1.14}, {"campaign": "POWER-SP-EXACT-5 Support - eyelash serum", "spend": 219.73, "sales": 221.88, "clicks": 118, "impr": 37280, "orders": 13, "cpc": 1.86, "acos": 99.0, "cvr": 11.0, "ctr": 0.32, "roas": 1.01}, {"campaign": "POWER-SP-EXACT-5 HERO", "spend": 106.49, "sales": 89.95, "clicks": 80, "impr": 39245, "orders": 5, "cpc": 1.33, "acos": 118.4, "cvr": 6.2, "ctr": 0.2, "roas": 0.84}, {"campaign": "SP - CAT", "spend": 67.95, "sales": 41.98, "clicks": 50, "impr": 8806, "orders": 2, "cpc": 1.36, "acos": 161.9, "cvr": 4.0, "ctr": 0.57, "roas": 0.62}, {"campaign": "Ruminae-Brand Keywords-All Match", "spend": 56.75, "sales": 239.87, "clicks": 47, "impr": 2519, "orders": 12, "cpc": 1.21, "acos": 23.7, "cvr": 25.5, "ctr": 1.87, "roas": 4.23}, {"campaign": "SP - PAT - Nuorganic/Vibeauty/Eight Saints", "spend": 49.75, "sales": 35.98, "clicks": 24, "impr": 4339, "orders": 2, "cpc": 2.07, "acos": 138.3, "cvr": 8.3, "ctr": 0.55, "roas": 0.72}, {"campaign": "Regene-SP-Repair-Keratin Keywords", "spend": 14.35, "sales": 47.98, "clicks": 8, "impr": 1085, "orders": 2, "cpc": 1.79, "acos": 29.9, "cvr": 25.0, "ctr": 0.74, "roas": 3.34}, {"campaign": "SKC-POWER-eye lash serum growth", "spend": 6.0, "sales": 17.99, "clicks": 4, "impr": 5213, "orders": 1, "cpc": 1.5, "acos": 33.4, "cvr": 25.0, "ctr": 0.08, "roas": 3.0}, {"campaign": "SKC-POWER-clear mascara with growth serum", "spend": 4.47, "sales": 0.0, "clicks": 3, "impr": 163, "orders": 0, "cpc": 1.49, "acos": 0, "cvr": 0.0, "ctr": 1.84, "roas": 0.0}, {"campaign": "SKC-POWER-prostaglandin free eyelash serum", "spend": 3.96, "sales": 0.0, "clicks": 3, "impr": 896, "orders": 0, "cpc": 1.32, "acos": 0, "cvr": 0.0, "ctr": 0.33, "roas": 0.0}, {"campaign": "YUNEL28-SP-AUTO", "spend": 3.06, "sales": 0.0, "clicks": 4, "impr": 1920, "orders": 0, "cpc": 0.77, "acos": 0, "cvr": 0.0, "ctr": 0.21, "roas": 0.0}, {"campaign": "SKC-POWER-korean eyelash serum", "spend": 2.94, "sales": 0.0, "clicks": 2, "impr": 1858, "orders": 0, "cpc": 1.47, "acos": 0, "cvr": 0.0, "ctr": 0.11, "roas": 0.0}, {"campaign": "SKC-POWER-lash thickening serum", "spend": 2.0, "sales": 0.0, "clicks": 1, "impr": 43, "orders": 0, "cpc": 2.0, "acos": 0, "cvr": 0.0, "ctr": 2.33, "roas": 0.0}, {"campaign": "SKC-POWER-lash serum for eyelash growth", "spend": 1.5, "sales": 0.0, "clicks": 1, "impr": 55, "orders": 0, "cpc": 1.5, "acos": 0, "cvr": 0.0, "ctr": 1.82, "roas": 0.0}, {"campaign": "SKC-POWER-eyelash growth serum mascara", "spend": 1.4, "sales": 0.0, "clicks": 1, "impr": 91, "orders": 0, "cpc": 1.4, "acos": 0, "cvr": 0.0, "ctr": 1.1, "roas": 0.0}, {"campaign": "SKC-POWER-growth serum mascara", "spend": 1.4, "sales": 0.0, "clicks": 1, "impr": 19, "orders": 0, "cpc": 1.4, "acos": 0, "cvr": 0.0, "ctr": 5.26, "roas": 0.0}, {"campaign": "YUNEL28-SP-Branded", "spend": 0.45, "sales": 0.0, "clicks": 1, "impr": 7, "orders": 0, "cpc": 0.45, "acos": 0, "cvr": 0.0, "ctr": 14.29, "roas": 0.0}, {"campaign": "SKC-POWER-lash serum for sensitive eyes", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 40, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"campaign": "SP - Auto - B2B", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 84, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"campaign": "SP - Broad - B2B - eyebrow serum to grow brows", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 9, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"campaign": "SP - Exact - B2B - lash serum without prostaglandin", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 141, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}, {"campaign": "SKC-POWER-eyelash growth serum with brush", "spend": 0.0, "sales": 0.0, "clicks": 0, "impr": 14, "orders": 0, "cpc": 0, "acos": 0, "cvr": 0, "ctr": 0.0, "roas": 0}];
const BIZ_DATA  = [{"asin": "B0DF7DC877", "title": "Ruminae Korean Eyelash Growth Serum | Eyebrow Serum to Grow Brows & Lashes | Biotin, Peptides & Centella | Prostaglandin-Free, Non-Irritating | Dual Applicator | Korean Skincare | 0.3 fl oz (10 ml)", "sales": 3668.16, "orders": 202, "units": 205, "sessions": 1596, "ppc_orders": 76, "org_orders": 126, "org_pct": 62.4}, {"asin": "B0F1LX4D5D", "title": "Ruminae Advanced Lash Repair Serum for Damaged or Extension-Weakened Lashes | PDRN & EGF Recovery Formula with Keratin, Peptides & Amino Acids | Prostaglandin-Free, Korean Lash Serum (0.3 fl oz)", "sales": 695.71, "orders": 29, "units": 29, "sessions": 485, "ppc_orders": 2, "org_orders": 27, "org_pct": 93.1}, {"asin": "B0F1M6YLVJ", "title": "Retinol 0.1% Eye Cream with Bakuchiol 0.5% | Sensitive Skin Retinol for Wrinkles, Fine Lines & Dark Circles | Suitable for Face & Under-Eye Area | Korean Skincare | 30 ml (1.01 fl oz)", "sales": 39.0, "orders": 2, "units": 2, "sessions": 39, "ppc_orders": 0, "org_orders": 2, "org_pct": 100.0}, {"asin": "B0GDMX1H5D", "title": "YUNEL28 Korean Daily Barrier Moisturizer 50ml | For All Skin Types | PDRN, TECA, Niacinamide & Hyaluronic Acid | Clinic-Developed Cream, Lightweight & Non-Greasy, Fragrance Free | Korean Skincare", "sales": 24.9, "orders": 1, "units": 1, "sessions": 46, "ppc_orders": 0, "org_orders": 1, "org_pct": 100.0}, {"asin": "B0FNVQQ87Q", "title": "Daily Lash Serum & Renitol 0.1 Cream", "sales": 0.0, "orders": 0, "units": 0, "sessions": 5, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}, {"asin": "B0DZG5X4ZD", "title": "Ruminae Bouncy Eye Serum with 12 Peptides + Collagen, Cooling Jelly Texture for Puffy Eyes, Dark Circles & Hydration, Fragrance Free Korean Skincare, 30ml", "sales": 0.0, "orders": 0, "units": 0, "sessions": 25, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}, {"asin": "B0FZLPP1WP", "title": "Ruminae Lash Serum for Damaged, Thin or Extension-Weakened Lashes | Eyelash & Brow Growth Serum with PDRN, EGF, 20 Amino Acids & 9 Peptides | Gentle Korean Formula, Prostaglandin-Free (0.3fl oz)", "sales": 0.0, "orders": 0, "units": 0, "sessions": 1, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}, {"asin": "B0FCFGBSX8", "title": "Ruminae Intensive Care Bundle - Bouncy Eye Serum (Vegan Collagen, Peptide 12) & Regene Eyelash Serum (PDRN, Peptides) | Korean Skincare Set for Fuller Lashes, Puffiness & Fine Lines", "sales": 0.0, "orders": 0, "units": 0, "sessions": 5, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}, {"asin": "B0FFH4DFT6", "title": "Ruminae Lash & Glow Duo \u2013 Power & Volume Eyelash Serum (Biotin, Hyaluronic Acid, Peptides) + Bouncy Eye Serum (Vegan Collagen, Peptide 12) | Korean Skin Care Set for Fuller Lashes, Hydrated Eyes", "sales": 0.0, "orders": 0, "units": 0, "sessions": 6, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}, {"asin": "B0FS7PJNQF", "title": "Ruminae Morning & Night Eye Care Bundle | Bouncy Collagen Serum (AM) + Smooth Retinol Cream (PM)", "sales": 0.0, "orders": 0, "units": 0, "sessions": 4, "ppc_orders": 0, "org_orders": 0, "org_pct": 0}];
const PROD_DATA = [{"product": "B0DF7DC877-1-stickerless", "sales": 1421.24, "spend": 1251.55, "clicks": 818, "impr": 356636, "orders": 76, "cvr": 9.0, "cpc": 1.53, "ctr": 0.0, "acos": 88.0, "roas": 1.14}, {"product": "B0F1LX4D5D-SC-MVE0-96K6", "sales": 47.98, "spend": 17.79, "clicks": 9, "impr": 1092, "orders": 2, "cvr": 22.0, "cpc": 1.98, "ctr": 1.0, "acos": 37.0, "roas": 2.7}, {"product": "B0GDMX1H5D-M8-KY96-YHUB", "sales": 0.0, "spend": 3.51, "clicks": 5, "impr": 1927, "orders": 0, "cvr": 0.0, "cpc": 0.7, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0DZG5X4ZD-1Q-35I7-MDFV", "sales": 0.0, "spend": 2.35, "clicks": 2, "impr": 167, "orders": 0, "cvr": 0.0, "cpc": 1.18, "ctr": 1.0, "acos": 0.0, "roas": 0.0}, {"product": "B0F1M6YLVJ-31-0RQX-AAI2", "sales": 0.0, "spend": 2.34, "clicks": 1, "impr": 405, "orders": 0, "cvr": 0.0, "cpc": 2.34, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0DF7DC877-1", "sales": 0.0, "spend": 1.5, "clicks": 1, "impr": 58, "orders": 0, "cvr": 0.0, "cpc": 1.5, "ctr": 2.0, "acos": 0.0, "roas": 0.0}, {"product": "B0BXF844KF-KR-59AL-9IVG", "sales": 0.0, "spend": 0.0, "clicks": 0, "impr": 0, "orders": 0, "cvr": 0.0, "cpc": 0.0, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0BXFB1HX8-NN-F9E5-4QL3", "sales": 0.0, "spend": 0.0, "clicks": 0, "impr": 0, "orders": 0, "cvr": 0.0, "cpc": 0.0, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0DF7DC877", "sales": 0.0, "spend": 0.0, "clicks": 0, "impr": 0, "orders": 0, "cvr": 0.0, "cpc": 0.0, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0FCFGBSX8-bouncyregene01", "sales": 0.0, "spend": 0.0, "clicks": 0, "impr": 0, "orders": 0, "cvr": 0.0, "cpc": 0.0, "ctr": 0.0, "acos": 0.0, "roas": 0.0}, {"product": "B0FFH4DFT6-pvbouncy01", "sales": 0.0, "spend": 0.0, "clicks": 0, "impr": 0, "orders": 0, "cvr": 0.0, "cpc": 0.0, "ctr": 0.0, "acos": 0.0, "roas": 0.0}];

// ─── TABLE STATE ────────────────────────────────────────────────────────────
const STATE = {};
const PAGE_SIZE = 50;

function initState(key, data) {
  STATE[key] = { data, filtered: [...data], sortCol: -1, sortDir: 1, page: 0 };
}

// ─── FORMAT HELPERS ─────────────────────────────────────────────────────────
const f$ = v => '£' + (v||0).toLocaleString('en-GB', {minimumFractionDigits:2,maximumFractionDigits:2});
const fn = v => (v||0).toLocaleString('en-GB');
const fp = v => (v||0).toFixed(1) + '%';
const f2 = v => (v||0).toFixed(2);

function acosClass(v) {
  if (v < 40) return 'badge-green';
  if (v < 65) return 'badge-amber';
  return 'badge-red';
}
function cvrClass(v) {
  if (v >= 10) return 'badge-green';
  if (v >= 6) return 'badge-amber';
  return 'badge-red';
}
function orgClass(v) {
  if (v >= 50) return 'badge-green';
  if (v >= 25) return 'badge-amber';
  return 'badge-red';
}

// ─── SORT ──────────────────────────────────────────────────────────────────
const COL_KEYS = {
  st:   ['term','sales','spend','acos','roas','orders','clicks','cvr','impr','cpc','ctr'],
  tgt:  ['target','campaign','sales','spend','acos','roas','orders','clicks','cvr','impr','cpc'],
  camp: ['campaign','sales','spend','acos','roas','orders','clicks','cvr','impr','cpc','ctr'],
  biz:  ['asin','title','sales','orders','units','sessions','ppc_orders','org_orders','org_pct'],
  prod: ['product','sales','spend','acos','roas','orders','clicks','cvr','impr','cpc'],
};

function sortTable(key, col) {
  const s = STATE[key];
  if (s.sortCol === col) s.sortDir *= -1;
  else { s.sortCol = col; s.sortDir = -1; } // default desc
  const field = COL_KEYS[key][col];
  s.filtered.sort((a,b) => {
    const av = a[field], bv = b[field];
    if (typeof av === 'number') return s.sortDir * (bv - av);
    return s.sortDir * String(av).localeCompare(String(bv));
  });
  s.page = 0;
  // update header icons
  const tbl = document.getElementById('tbl-' + key);
  tbl.querySelectorAll('thead th').forEach((th, i) => {
    th.classList.remove('sort-asc','sort-desc');
    if (i === col) th.classList.add(s.sortDir === -1 ? 'sort-desc' : 'sort-asc');
  });
  renderTable(key);
}

// ─── FILTER ─────────────────────────────────────────────────────────────────
function filterTable(key) {
  const s = STATE[key];
  const q = (document.getElementById(key+'-search') || {}).value?.toLowerCase() || '';
  s.filtered = s.data.filter(r => Object.values(r).some(v => String(v).toLowerCase().includes(q)));
  s.page = 0;
  renderTable(key);
}

// ─── RENDER TABLES ──────────────────────────────────────────────────────────
function renderTable(key) {
  const s = STATE[key];
  const start = s.page * PAGE_SIZE;
  const slice = s.filtered.slice(start, start + PAGE_SIZE);
  const tbody = document.getElementById('tbody-' + key);
  const countEl = document.getElementById(key + '-count');
  if (countEl) countEl.textContent = '(' + s.filtered.length + ' rows)';
  
  const rows = slice.map(r => rowHtml(key, r)).join('');
  tbody.innerHTML = rows;
  renderPager(key);
}

function rowHtml(key, r) {
  if (key === 'st') {
    return `<tr>
      <td class="text-cell">${r.term}</td>
      <td>${f$(r.sales)}</td>
      <td>${f$(r.spend)}</td>
      <td><span class="badge ${acosClass(r.acos)}">${fp(r.acos)}</span></td>
      <td>${f2(r.roas)}</td>
      <td>${fn(r.orders)}</td>
      <td>${fn(r.clicks)}</td>
      <td><span class="badge ${cvrClass(r.cvr)}">${fp(r.cvr)}</span></td>
      <td>${fn(r.impr)}</td>
      <td>${f$(r.cpc)}</td>
      <td>${fp(r.ctr)}</td>
    </tr>`;
  }
  if (key === 'tgt') {
    return `<tr>
      <td class="text-cell">${r.target}</td>
      <td class="text-cell">${r.campaign}</td>
      <td>${f$(r.sales)}</td>
      <td>${f$(r.spend)}</td>
      <td><span class="badge ${acosClass(r.acos)}">${fp(r.acos)}</span></td>
      <td>${f2(r.roas)}</td>
      <td>${fn(r.orders)}</td>
      <td>${fn(r.clicks)}</td>
      <td><span class="badge ${cvrClass(r.cvr)}">${fp(r.cvr)}</span></td>
      <td>${fn(r.impr)}</td>
      <td>${f$(r.cpc)}</td>
    </tr>`;
  }
  if (key === 'camp') {
    return `<tr>
      <td class="text-cell">${r.campaign}</td>
      <td>${f$(r.sales)}</td>
      <td>${f$(r.spend)}</td>
      <td><span class="badge ${acosClass(r.acos)}">${fp(r.acos)}</span></td>
      <td>${f2(r.roas)}</td>
      <td>${fn(r.orders)}</td>
      <td>${fn(r.clicks)}</td>
      <td><span class="badge ${cvrClass(r.cvr)}">${fp(r.cvr)}</span></td>
      <td>${fn(r.impr)}</td>
      <td>${f$(r.cpc)}</td>
      <td>${fp(r.ctr)}</td>
    </tr>`;
  }
  if (key === 'biz') {
    return `<tr>
      <td><strong>${r.asin}</strong></td>
      <td class="text-cell" style="font-size:0.8rem">${r.title}</td>
      <td>${f$(r.sales)}</td>
      <td>${fn(r.orders)}</td>
      <td>${fn(r.units)}</td>
      <td>${fn(r.sessions)}</td>
      <td>${fn(r.ppc_orders)}</td>
      <td>${fn(r.org_orders)}</td>
      <td><span class="badge ${orgClass(r.org_pct)}">${fp(r.org_pct)}</span></td>
    </tr>`;
  }
  if (key === 'prod') {
    return `<tr>
      <td class="text-cell">${r.product}</td>
      <td>${f$(r.sales)}</td>
      <td>${f$(r.spend)}</td>
      <td><span class="badge ${acosClass(r.acos)}">${fp(r.acos)}</span></td>
      <td>${f2(r.roas)}</td>
      <td>${fn(r.orders)}</td>
      <td>${fn(r.clicks)}</td>
      <td><span class="badge ${cvrClass(r.cvr)}">${fp(r.cvr)}</span></td>
      <td>${fn(r.impr)}</td>
      <td>${f$(r.cpc)}</td>
    </tr>`;
  }
  return '';
}

// ─── PAGER ──────────────────────────────────────────────────────────────────
function renderPager(key) {
  const s = STATE[key];
  const total = s.filtered.length;
  const pages = Math.ceil(total / PAGE_SIZE);
  const el = document.getElementById('pager-' + key);
  if (pages <= 1) { el.innerHTML = ''; return; }
  let html = '';
  const start = Math.max(0, s.page - 2);
  const end = Math.min(pages - 1, s.page + 2);
  if (start > 0) html += `<button onclick="gotoPage('${key}',0)">1</button>`;
  if (start > 1) html += `<span>…</span>`;
  for (let i = start; i <= end; i++) {
    html += `<button class="${i===s.page?'active':''}" onclick="gotoPage('${key}',${i})">${i+1}</button>`;
  }
  if (end < pages - 2) html += `<span>…</span>`;
  if (end < pages - 1) html += `<button onclick="gotoPage('${key}',${pages-1})">${pages}</button>`;
  const rowStart = s.page * PAGE_SIZE + 1;
  const rowEnd = Math.min(rowStart + PAGE_SIZE - 1, total);
  html += `<span class="pager-info">Showing ${rowStart}–${rowEnd} of ${total}</span>`;
  el.innerHTML = html;
}

function gotoPage(key, page) {
  STATE[key].page = page;
  renderTable(key);
}

// ─── TAB NAV ────────────────────────────────────────────────────────────────
function showTab(id) {
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.nav-btn').forEach(b => b.classList.remove('active'));
  document.getElementById('tab-' + id).classList.add('active');
  event.target.classList.add('active');
}

// ─── CHARTS ─────────────────────────────────────────────────────────────────
const ORANGE = '#e87722', ORANGE2 = '#f5a623', BLUE = '#1565c0', BLUE2 = '#42a5f5';

function mkChart(id, type, labels, datasets, opts) {
  const ctx = document.getElementById(id).getContext('2d');
  new Chart(ctx, { type, data: { labels, datasets }, options: { responsive:true, plugins:{ legend:{position:'top'} }, ...opts } });
}

function buildCharts() {
  mkChart('c-spend-sales', 'bar', ['W19','W20'], [
    { label:'Spend (£)', data:[742, 630], backgroundColor: ORANGE },
    { label:'Sales (£)', data:[905, 695], backgroundColor: ORANGE2 }
  ], { scales: { y:{ ticks:{ callback: v => '£'+v } } } });

  mkChart('c-acos', 'bar', ['W19','W20'], [
    { label:'ACOS %', data:[82.0, 90.6], backgroundColor:[ORANGE, ORANGE2] }
  ], { scales: { y:{ ticks:{ callback: v => v+'%' } } } });

  mkChart('c-orders', 'bar', ['W19','W20'], [
    { label:'PPC Orders', data:[49, 37], backgroundColor: BLUE },
    { label:'Total Orders', data:[116, 118], backgroundColor: BLUE2 }
  ], {});

  mkChart('c-cpc-cvr', 'bar', ['W19','W20'], [
    { label:'CPC (£)', data:[1.48, 1.42], backgroundColor: ORANGE, yAxisID:'y' },
    { label:'CVR %', data:[9.8, 8.3], backgroundColor: BLUE2, yAxisID:'y2' }
  ], {
    scales: {
      y:  { type:'linear', position:'left',  ticks:{ callback: v=>'£'+v } },
      y2: { type:'linear', position:'right', ticks:{ callback: v=>v+'%' }, grid:{ drawOnChartArea:false } }
    }
  });
}

// ─── INIT ────────────────────────────────────────────────────────────────────
initState('st',   ST_DATA);
initState('tgt',  TGT_DATA);
initState('camp', CAMP_DATA);
initState('biz',  BIZ_DATA);
initState('prod', PROD_DATA);

renderTable('st');
renderTable('tgt');
renderTable('camp');
renderTable('biz');
renderTable('prod');

buildCharts();
</script>
</body>
</html>
