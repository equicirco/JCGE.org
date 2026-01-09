# Equations
`prod.eqZ[BRD]`

$$
\mathrm{Z}_{j} = \mathrm{b}_{j} \cdot \prod_{h \in \mathcal{D}_{h}} {\mathrm{F}_{h,j}}^{beta_{h,j}}
$$

Domain h in { CAP, LAB }

`prod.eqF[CAP,BRD]`

$$
\mathrm{F}_{h,j} = \mathrm{beta}_{h,j} \cdot \mathrm{pz}_{j} \cdot \mathrm{Z}_{j} / \mathrm{pf}_{h}
$$

`prod.eqF[LAB,BRD]`

$$
\mathrm{F}_{h,j} = \mathrm{beta}_{h,j} \cdot \mathrm{pz}_{j} \cdot \mathrm{Z}_{j} / \mathrm{pf}_{h}
$$

`prod.eqZ[MLK]`

$$
\mathrm{Z}_{j} = \mathrm{b}_{j} \cdot \prod_{h \in \mathcal{D}_{h}} {\mathrm{F}_{h,j}}^{beta_{h,j}}
$$

Domain h in { CAP, LAB }

`prod.eqF[CAP,MLK]`

$$
\mathrm{F}_{h,j} = \mathrm{beta}_{h,j} \cdot \mathrm{pz}_{j} \cdot \mathrm{Z}_{j} / \mathrm{pf}_{h}
$$

`prod.eqF[LAB,MLK]`

$$
\mathrm{F}_{h,j} = \mathrm{beta}_{h,j} \cdot \mathrm{pz}_{j} \cdot \mathrm{Z}_{j} / \mathrm{pf}_{h}
$$

`factor_market.eqF[CAP]`

$$
\sum_{j \in \mathcal{D}_{j}} \mathrm{F}_{h,j} = \mathrm{FF}_{h}
$$

Domain j in { BRD, MLK }

`factor_market.eqF[LAB]`

$$
\sum_{j \in \mathcal{D}_{j}} \mathrm{F}_{h,j} = \mathrm{FF}_{h}
$$

Domain j in { BRD, MLK }

`household.eqX[BRD]`

$$
\mathrm{X}_{i} = \mathrm{alpha}_{i} \cdot \sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} / \mathrm{px}_{i}
$$

Domain h in { CAP, LAB }

`household.eqX[MLK]`

$$
\mathrm{X}_{i} = \mathrm{alpha}_{i} \cdot \sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} / \mathrm{px}_{i}
$$

Domain h in { CAP, LAB }

`price_link.eqP[BRD]`

$$
\mathrm{px}_{i} = \mathrm{pz}_{i}
$$

`price_link.eqP[MLK]`

$$
\mathrm{px}_{i} = \mathrm{pz}_{i}
$$

`goods_market.eqX[BRD]`

$$
\mathrm{X}_{i} = \mathrm{Z}_{i}
$$

`goods_market.eqX[MLK]`

$$
\mathrm{X}_{i} = \mathrm{Z}_{i}
$$

`utility.objective` maximize Cobb-Douglas utility

`init.start[F_LAB_MLK]` start F_LAB_MLK = 15.0

`init.start[F_LAB_BRD]` start F_LAB_BRD = 10.0

`init.start[Z_BRD]` start Z_BRD = 15.0

`init.start[px_BRD]` start px_BRD = 1.0

`init.start[F_CAP_MLK]` start F_CAP_MLK = 20.0

`init.start[pz_MLK]` start pz_MLK = 1.0

`init.start[px_MLK]` start px_MLK = 1.0

`init.start[pz_BRD]` start pz_BRD = 1.0

`init.start[pf_LAB]` start pf_LAB = 1.0

`init.start[X_BRD]` start X_BRD = 15.0

`init.start[Z_MLK]` start Z_MLK = 35.0

`init.start[pf_CAP]` start pf_CAP = 1.0

`init.start[F_CAP_BRD]` start F_CAP_BRD = 5.0

`init.start[X_MLK]` start X_MLK = 35.0

`init.lower[F_LAB_MLK]` lower F_LAB_MLK = 0.001

`init.lower[F_LAB_BRD]` lower F_LAB_BRD = 0.001

`init.lower[Z_BRD]` lower Z_BRD = 0.001

`init.lower[px_BRD]` lower px_BRD = 0.001

`init.lower[F_CAP_MLK]` lower F_CAP_MLK = 0.001

`init.lower[pz_MLK]` lower pz_MLK = 0.001

`init.lower[pz_BRD]` lower pz_BRD = 0.001

`init.lower[pf_LAB]` lower pf_LAB = 0.001

`init.lower[px_MLK]` lower px_MLK = 0.001

`init.lower[X_BRD]` lower X_BRD = 0.001

`init.lower[Z_MLK]` lower Z_MLK = 0.001

`init.lower[pf_CAP]` lower pf_CAP = 0.001

`init.lower[F_CAP_BRD]` lower F_CAP_BRD = 0.001

`init.lower[X_MLK]` lower X_MLK = 0.001

`numeraire.numeraire` numeraire fixed
