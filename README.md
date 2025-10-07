# The-impact-of-informal-competition-on-product-and-process-innovation-in-Vietnam

📘 **A Ministry-Level Scientific Research Project (NEU, Vietnam)**  
📅 **Period:** 2022 – 2025  
🧾 **Last Updated:** October 2025  

---

## 👩‍💼 Authors & Supervision

**Research Team:**  
- Le Tri Nhan (Lê Trí Nhân)  
- Nguyen Thi Ngoc Anh (Nguyễn Thị Ngọc Anh)  
- Nguyen Linh Trang (Nguyễn Linh Trang)  
- Le Viet Hoang (Lê Việt Hoàng)  
🎓 *School of Management Science, National Economics University (NEU), Hanoi, Vietnam*

**Academic Supervisor:**  
- Dr. Tran Lan Huong (Trần Lan Hương), NEU  

📄 *Ministry-Level Research Grant (2022): “The Impact of Informal Competition on Firm Innovation: Evidence from Vietnam and Emerging ASEAN Economies.”*  

---

## 🧭 Overview

This repository provides the **replication materials**, **code**, and **outputs** for the above research project.  
The study explores how **informal competition**—an inherent feature of emerging markets—affects the **innovation behavior** of formal firms, with a focus on **product** and **process innovation**.  

We also examine how the **legal and regulatory environment** moderates this relationship, drawing on **institutional theory** and the **bounded rationality** framework.

**Data Source:** World Bank Enterprise Surveys (WBES, 2015–2016)  
**Sample:** Vietnam, Thailand, Cambodia, and the Philippines (subset of ASEAN-5 due to data completeness).  
**Method:** Logistic regression with robust errors and interaction effects.  

---

## 🧩 Repository Structure
```
InformalCompetition_Innovation/
┣ code/
┃ ┣ do_file_cap_bo_2022_FINAL.do
┣ data/
┃ ┣ Vietnam2015.dta
┃ ┣ Thailand-2016-full-data.dta
┃ ┣ Cambodia-2016-full-data.dta
┃ ┗ Philippines-2015-full-data.dta
┣ output/
┃ ┣ tables/
┃ ┃ ┣ result_ALL.doc
┃ ┃ ┣ result_VN.doc
┃ ┃ ┣ result_VN_quad.doc
┃ ┃ ┗ result_moderation.doc
┃ ┗ figures/
┃ ┣ figure1_product_linear.png
┃ ┣ figure2_process_linear.png
┃ ┣ figure3_process_Ushape.png
┃ ┗ figure4_moderation_j30c.png
┗ README.md
```

## 🎯 Research Objectives

1. Assess the direct impact of informal competition on firm innovation.  
2. Examine non-linear (inverted U-shaped) relationships between informal competition and innovation.  
3. Identify the moderating role of legal/regulatory barriers on these effects.  
4. Provide policy insights for fostering innovation under informal market pressures.  

---

## 🧩 Hypotheses

| ID | Hypothesis | Expected Relationship |
|----|-------------|----------------------|
| H1a | Informal competition → Product innovation | Positive (+) |
| H1b | Non-linear (IC²) → Product innovation | Weak / Not significant |
| H2a | Informal competition → Process innovation | Positive (+) |
| H2b | Non-linear (IC²) → Process innovation | Inverted U-shape (−) |
| H3 | Legal/regulatory barriers (j30c) moderate the relationship between informal competition and innovation | Positive moderation (+) |

---

## 🧮 Model Framework

**Baseline (Logit):**  
logit(Innovation_i) = β₀ + β₁·e30_i + β₂·Controls_i + ε_i  

**Quadratic form (Inverted U-shape):**  
logit(Innovation_i) = β₀ + β₁·e30_i + β₂·(e30_i)² + β₃·Controls_i + ε_i  

**Moderated model:**  
logit(Innovation_i) = β₀ + β₁·e30_i + β₂·(e30_i)² + β₃·j30c_i + β₄·(e30_i × j30c_i) + β₅·Controls_i + ε_i  

---

## 🧠 Variable Summary

| Variable | Description | Type |
|-----------|-------------|------|
| h1 | Product innovation (binary: 1=yes) | Dependent |
| pci1 | Process innovation (binary: 1=yes) | Dependent |
| e30 | Informal competition (0–4 scale, WBES) | Independent |
| ICsq | Squared informal competition | Non-linear term |
| j30c | Legal/regulatory barriers | Moderator |
| e30xj30c | Interaction term (e30 × j30c) | Moderation |
| age | Firm age | Control |
| size | Firm size (ln of employment) | Control |
| lnexperience | Top manager’s experience (logged) | Control |
| b2b, b2c | Foreign and state ownership shares | Control |
| j6a | Government contract | Control |
| i.a4a | Industry fixed effects | Control |

---

## ⚙️ Methodology Overview

1. Data Merging — Combine WBES data from four ASEAN economies.  
2. Cleaning & Recoding — Replace all negative survey codes (−7, −8, −9, −4) with missing values.  
3. Variable Construction — Compute size, age, logged experience, innovation dummies, and squared terms.  
4. Model Estimation —  
   - Logit (linear) models for H1a, H2a  
   - Logit (quadratic) models for H1b, H2b  
   - Moderation models for H3 (j30c interaction)  
5. Marginal Effects & Visualization —  
   - margins, marginsplot in Stata  
   - Figures exported as PNG (2000×1400 pixels)  

---

## 📊 Main Findings

✅ **Product Innovation (h1):**  
Informal competition has a **positive linear effect** on product innovation in Vietnam and across ASEAN.  
The non-linear term is **insignificant**, confirming H1a but not H1b.  

✅ **Process Innovation (pci1):**  
Informal competition demonstrates an **inverted U-shaped relationship** with process innovation —  
moderate levels stimulate innovation, but excessive competition suppresses it. (Supports H2b.)  

✅ **Moderation (j30c – Legal Barriers):**  
A stronger legal/regulatory environment **enhances** the positive effects of informal competition,  
suggesting that better institutional quality enables firms to innovate effectively under pressure.  

📈 **Control Variables:**  
Larger, older, and foreign-owned firms tend to innovate more; state ownership is negatively related to innovation.

---

## 🧾 Reproducibility Instructions

**User-written packages:**  
- ssc install asdoc  
- ssc install spost13_ado  

### ▶️ Run the Pipeline

1. Open the file **do_file_cap_bo_2022_FINAL.do**.  
2. Set your working directory by adding the line:  
   cd "your_data_path"  
3. Ensure that all `.dta` files (Vietnam, Thailand, Cambodia, Philippines) are located in the `/data/` folder.  
4. Execute the script by running the command:  
   do do_file_cap_bo_2022_FINAL.do  

**Outputs will automatically appear under:**  
- 📁 output/tables/ — Word-formatted regression results (using asdoc)  
- 📁 output/figures/ — PNG graphs for publication  

---

## 🧩 Policy Implications

- Encourage **fair market competition** by reducing informality and administrative burdens.  
- Strengthen **regulatory quality** to enhance innovation responses to market pressure.  
- Target **innovation support** toward SMEs facing intense informal competition.  
- Simplify **legal frameworks** to help formal firms adapt faster and innovate more efficiently.  

---

## 🧠 Limitations & Future Research

- The cross-sectional **WBES** data restricts causal inference.  
- The impact of **legal barriers** may differ across sectors or firm sizes; future studies should investigate these contexts in depth.  
- Including **Malaysia** and **Indonesia** in future datasets would complete ASEAN-5 coverage and improve generalizability.  

---

## 📚 Citation

Le Tri Nhan, Nguyen Thi Ngoc Anh, Nguyen Linh Trang, & Le Viet Hoang (2022).  
*The Impact of Informal Competition on Firm Innovation: Evidence from Emerging ASEAN Economies.*  
Ministry-Level Research Project, National Economics University (NEU), Hanoi, Vietnam.  

---

## Contact

**Corresponding author:**  
**Le Tri Nhan**  
School of Management Science, National Economics University (NEU), Hanoi, Vietnam  
letrinhan123@gmail.com
