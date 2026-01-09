# Equations
`prod.eqpy[BRD]`

$$
\mathrm{Y}_{i} = \mathrm{b}_{i} \cdot \prod_{h \in \mathcal{D}_{h}} \mathrm{F}_{h,i}^{\mathrm{beta}_{h,i}}
$$

Domain h in { CAP, LAB }

`prod.eqF[CAP,BRD]`

$$
\mathrm{F}_{h,i} = \frac{\mathrm{beta}_{h,i} \cdot \mathrm{py}_{i} \cdot \mathrm{Y}_{i}}{\mathrm{pf}_{h}}
$$

`prod.eqF[LAB,BRD]`

$$
\mathrm{F}_{h,i} = \frac{\mathrm{beta}_{h,i} \cdot \mathrm{py}_{i} \cdot \mathrm{Y}_{i}}{\mathrm{pf}_{h}}
$$

`prod.eqX[BRD,BRD]`

$$
\mathrm{X}_{j,i} = \mathrm{ax}_{j,i} \cdot \mathrm{Z}_{i}
$$

`prod.eqX[MLK,BRD]`

$$
\mathrm{X}_{j,i} = \mathrm{ax}_{j,i} \cdot \mathrm{Z}_{i}
$$

`prod.eqY[BRD]`

$$
\mathrm{Y}_{i} = \mathrm{ay}_{i} \cdot \mathrm{Z}_{i}
$$

`prod.eqpzs[BRD]`

$$
\mathrm{pz}_{i} = \mathrm{ay}_{i} \cdot \mathrm{py}_{i} + \sum_{j \in \mathcal{D}_{j}} \mathrm{ax}_{j,i} \cdot \mathrm{pq}_{j} + \frac{\mathrm{FC}_{i}}{\mathrm{Z}_{i}}
$$

Domain j in { BRD, MLK }

`prod.eqpy[MLK]`

$$
\mathrm{Y}_{i} = \mathrm{b}_{i} \cdot \prod_{h \in \mathcal{D}_{h}} \mathrm{F}_{h,i}^{\mathrm{beta}_{h,i}}
$$

Domain h in { CAP, LAB }

`prod.eqF[CAP,MLK]`

$$
\mathrm{F}_{h,i} = \frac{\mathrm{beta}_{h,i} \cdot \mathrm{py}_{i} \cdot \mathrm{Y}_{i}}{\mathrm{pf}_{h}}
$$

`prod.eqF[LAB,MLK]`

$$
\mathrm{F}_{h,i} = \frac{\mathrm{beta}_{h,i} \cdot \mathrm{py}_{i} \cdot \mathrm{Y}_{i}}{\mathrm{pf}_{h}}
$$

`prod.eqX[BRD,MLK]`

$$
\mathrm{X}_{j,i} = \mathrm{ax}_{j,i} \cdot \mathrm{Z}_{i}
$$

`prod.eqX[MLK,MLK]`

$$
\mathrm{X}_{j,i} = \mathrm{ax}_{j,i} \cdot \mathrm{Z}_{i}
$$

`prod.eqY[MLK]`

$$
\mathrm{Y}_{i} = \mathrm{ay}_{i} \cdot \mathrm{Z}_{i}
$$

`prod.eqpzs[MLK]`

$$
\mathrm{pz}_{i} = \mathrm{ay}_{i} \cdot \mathrm{py}_{i} + \sum_{j \in \mathcal{D}_{j}} \mathrm{ax}_{j,i} \cdot \mathrm{pq}_{j} + \frac{\mathrm{FC}_{i}}{\mathrm{Z}_{i}}
$$

Domain j in { BRD, MLK }

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

`government.eqTd`

$$
Td = tau\_d \cdot (\sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} + 0 + \sum_{i \in \mathcal{D}_{i}} \mathrm{FC}_{i})
$$

Domain h in { CAP, LAB }
Domain i in { BRD, MLK }

`government.eqTz[BRD]`

$$
\mathrm{Tz}_{i} = \mathrm{tau\_z}_{i} \cdot \mathrm{pz}_{i} \cdot \mathrm{Z}_{i}
$$

`government.eqTm[BRD]`

$$
\mathrm{Tm}_{i} = \mathrm{tau\_m}_{i} \cdot \mathrm{pm}_{i} \cdot \mathrm{M}_{i}
$$

`government.eqXg[BRD]`

$$
\mathrm{Xg}_{i} = \frac{\mathrm{mu}_{i} \cdot (Td + \sum_{j \in \mathcal{D}_{j}} \mathrm{Tz}_{j} + \sum_{j \in \mathcal{D}_{j}} \mathrm{Tm}_{j} - Sg)}{\mathrm{pq}_{i}}
$$

Domain j in { BRD, MLK }
Domain j in { BRD, MLK }

`government.eqTz[MLK]`

$$
\mathrm{Tz}_{i} = \mathrm{tau\_z}_{i} \cdot \mathrm{pz}_{i} \cdot \mathrm{Z}_{i}
$$

`government.eqTm[MLK]`

$$
\mathrm{Tm}_{i} = \mathrm{tau\_m}_{i} \cdot \mathrm{pm}_{i} \cdot \mathrm{M}_{i}
$$

`government.eqXg[MLK]`

$$
\mathrm{Xg}_{i} = \frac{\mathrm{mu}_{i} \cdot (Td + \sum_{j \in \mathcal{D}_{j}} \mathrm{Tz}_{j} + \sum_{j \in \mathcal{D}_{j}} \mathrm{Tm}_{j} - Sg)}{\mathrm{pq}_{i}}
$$

Domain j in { BRD, MLK }
Domain j in { BRD, MLK }

`government.eqSg`

$$
Sg = ssg \cdot (Td + \sum_{i \in \mathcal{D}_{i}} \mathrm{Tz}_{i} + \sum_{i \in \mathcal{D}_{i}} \mathrm{Tm}_{i})
$$

Domain i in { BRD, MLK }
Domain i in { BRD, MLK }

`private_saving.eqSp`

$$
Sp = ssp \cdot (\sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} + 0 + \sum_{i \in \mathcal{D}_{i}} \mathrm{FC}_{i})
$$

Domain h in { CAP, LAB }
Domain i in { BRD, MLK }

`investment.eqXv[BRD]`

$$
\mathrm{Xv}_{i} = \frac{\mathrm{lambda}_{i} \cdot (Sp + Sg + epsilon \cdot Sf)}{\mathrm{pq}_{i}}
$$

`investment.eqXv[MLK]`

$$
\mathrm{Xv}_{i} = \frac{\mathrm{lambda}_{i} \cdot (Sp + Sg + epsilon \cdot Sf)}{\mathrm{pq}_{i}}
$$

`household.eqXp[BRD]`

$$
\mathrm{Xp}_{i} = \frac{\mathrm{alpha}_{i} \cdot (\sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} - Sp - Td + 0 + \sum_{j \in \mathcal{D}_{j}} \mathrm{FC}_{j})}{\mathrm{pq}_{i}}
$$

Domain h in { CAP, LAB }
Domain j in { BRD, MLK }

`household.eqXp[MLK]`

$$
\mathrm{Xp}_{i} = \frac{\mathrm{alpha}_{i} \cdot (\sum_{h \in \mathcal{D}_{h}} \mathrm{pf}_{h} \cdot \mathrm{FF}_{h} - Sp - Td + 0 + \sum_{j \in \mathcal{D}_{j}} \mathrm{FC}_{j})}{\mathrm{pq}_{i}}
$$

Domain h in { CAP, LAB }
Domain j in { BRD, MLK }

`prices.eqpe[BRD]`

$$
\mathrm{pe}_{i} = epsilon \cdot \mathrm{pWe}_{i}
$$

`prices.eqpm[BRD]`

$$
\mathrm{pm}_{i} = epsilon \cdot \mathrm{pWm}_{i}
$$

`prices.eqpe[MLK]`

$$
\mathrm{pe}_{i} = epsilon \cdot \mathrm{pWe}_{i}
$$

`prices.eqpm[MLK]`

$$
\mathrm{pm}_{i} = epsilon \cdot \mathrm{pWm}_{i}
$$

`bop.eqBOP`

$$
\sum_{i \in \mathcal{D}_{i}} \mathrm{pWe}_{i} \cdot \mathrm{E}_{i} + Sf = \sum_{i \in \mathcal{D}_{i}} \mathrm{pWm}_{i} \cdot \mathrm{M}_{i}
$$

Domain i in { BRD, MLK }
Domain i in { BRD, MLK }

`armington.eqQ[BRD]`

$$
\mathrm{Q}_{i} = \mathrm{gamma}_{i} \cdot (\mathrm{delta\_m}_{i} \cdot \mathrm{M}_{i}^{\mathrm{eta}_{i}} + \mathrm{delta\_d}_{i} \cdot \mathrm{D}_{i}^{\mathrm{eta}_{i}})^{\frac{1}{\mathrm{eta}_{i}}}
$$

`armington.eqM[BRD]`

$$
\mathrm{M}_{i} = (\frac{\mathrm{gamma}_{i}^{\mathrm{eta}_{i}} \cdot \mathrm{delta\_m}_{i} \cdot \mathrm{pq}_{i}}{(1 + 0 + \mathrm{tau\_m}_{i}) \cdot \mathrm{pm}_{i}})^{\frac{1}{(1 - \mathrm{eta}_{i})}} \cdot \mathrm{Q}_{i}
$$

`armington.eqD[BRD]`

$$
\mathrm{D}_{i} = (\frac{\mathrm{gamma}_{i}^{\mathrm{eta}_{i}} \cdot \mathrm{delta\_d}_{i} \cdot \mathrm{pq}_{i}}{1 \cdot \mathrm{pd}_{i}})^{\frac{1}{(1 - \mathrm{eta}_{i})}} \cdot \mathrm{Q}_{i}
$$

`armington.eqQ[MLK]`

$$
\mathrm{Q}_{i} = \mathrm{gamma}_{i} \cdot (\mathrm{delta\_m}_{i} \cdot \mathrm{M}_{i}^{\mathrm{eta}_{i}} + \mathrm{delta\_d}_{i} \cdot \mathrm{D}_{i}^{\mathrm{eta}_{i}})^{\frac{1}{\mathrm{eta}_{i}}}
$$

`armington.eqM[MLK]`

$$
\mathrm{M}_{i} = (\frac{\mathrm{gamma}_{i}^{\mathrm{eta}_{i}} \cdot \mathrm{delta\_m}_{i} \cdot \mathrm{pq}_{i}}{(1 + 0 + \mathrm{tau\_m}_{i}) \cdot \mathrm{pm}_{i}})^{\frac{1}{(1 - \mathrm{eta}_{i})}} \cdot \mathrm{Q}_{i}
$$

`armington.eqD[MLK]`

$$
\mathrm{D}_{i} = (\frac{\mathrm{gamma}_{i}^{\mathrm{eta}_{i}} \cdot \mathrm{delta\_d}_{i} \cdot \mathrm{pq}_{i}}{1 \cdot \mathrm{pd}_{i}})^{\frac{1}{(1 - \mathrm{eta}_{i})}} \cdot \mathrm{Q}_{i}
$$

`transformation.eqZ[BRD]`

$$
\mathrm{Z}_{i} = \mathrm{theta}_{i} \cdot (\mathrm{xie}_{i} \cdot \mathrm{E}_{i}^{\mathrm{phi}_{i}} + \mathrm{xid}_{i} \cdot \mathrm{D}_{i}^{\mathrm{phi}_{i}})^{\frac{1}{\mathrm{phi}_{i}}}
$$

`transformation.eqE[BRD]`

$$
\mathrm{E}_{i} = (\frac{\mathrm{theta}_{i}^{\mathrm{phi}_{i}} \cdot \mathrm{xie}_{i} \cdot (1 + \mathrm{tau\_z}_{i}) \cdot \mathrm{pz}_{i}}{\mathrm{pe}_{i}})^{\frac{1}{(1 - \mathrm{phi}_{i})}} \cdot \mathrm{Z}_{i}
$$

`transformation.eqDs[BRD]`

$$
\mathrm{D}_{i} = (\frac{\mathrm{theta}_{i}^{\mathrm{phi}_{i}} \cdot \mathrm{xid}_{i} \cdot (1 + \mathrm{tau\_z}_{i}) \cdot \mathrm{pz}_{i}}{\mathrm{pd}_{i}})^{\frac{1}{(1 - \mathrm{phi}_{i})}} \cdot \mathrm{Z}_{i}
$$

`transformation.eqZ[MLK]`

$$
\mathrm{Z}_{i} = \mathrm{theta}_{i} \cdot (\mathrm{xie}_{i} \cdot \mathrm{E}_{i}^{\mathrm{phi}_{i}} + \mathrm{xid}_{i} \cdot \mathrm{D}_{i}^{\mathrm{phi}_{i}})^{\frac{1}{\mathrm{phi}_{i}}}
$$

`transformation.eqE[MLK]`

$$
\mathrm{E}_{i} = (\frac{\mathrm{theta}_{i}^{\mathrm{phi}_{i}} \cdot \mathrm{xie}_{i} \cdot (1 + \mathrm{tau\_z}_{i}) \cdot \mathrm{pz}_{i}}{\mathrm{pe}_{i}})^{\frac{1}{(1 - \mathrm{phi}_{i})}} \cdot \mathrm{Z}_{i}
$$

`transformation.eqDs[MLK]`

$$
\mathrm{D}_{i} = (\frac{\mathrm{theta}_{i}^{\mathrm{phi}_{i}} \cdot \mathrm{xid}_{i} \cdot (1 + \mathrm{tau\_z}_{i}) \cdot \mathrm{pz}_{i}}{\mathrm{pd}_{i}})^{\frac{1}{(1 - \mathrm{phi}_{i})}} \cdot \mathrm{Z}_{i}
$$

`market.eqQ[BRD]`

$$
\mathrm{Q}_{i} = \mathrm{Xp}_{i} + \mathrm{Xg}_{i} + \mathrm{Xv}_{i} + \sum_{j \in \mathcal{D}_{j}} \mathrm{X}_{i,j}
$$

Domain j in { BRD, MLK }

`market.eqQ[MLK]`

$$
\mathrm{Q}_{i} = \mathrm{Xp}_{i} + \mathrm{Xg}_{i} + \mathrm{Xv}_{i} + \sum_{j \in \mathcal{D}_{j}} \mathrm{X}_{i,j}
$$

Domain j in { BRD, MLK }

`utility.objective` maximize Cobb-Douglas utility over Xp

`init.start[X_MLK_BRD]` start X_MLK_BRD = 17.0

`init.start[F_LAB_BRD]` start F_LAB_BRD = 15.0

`init.start[X_MLK_MLK]` start X_MLK_MLK = 9.0

`init.start[pd_MLK]` start pd_MLK = 1.0

`init.start[F_CAP_MLK]` start F_CAP_MLK = 27.0

`init.start[pz_MLK]` start pz_MLK = 1.0

`init.start[pz_BRD]` start pz_BRD = 1.0

`init.start[Xg_MLK]` start Xg_MLK = 14.0

`init.start[pm_BRD]` start pm_BRD = 1.0

`init.start[X_BRD_BRD]` start X_BRD_BRD = 21.0

`init.start[Tm_BRD]` start Tm_BRD = 1.0

`init.start[pd_BRD]` start pd_BRD = 1.0

`init.start[M_BRD]` start M_BRD = 13.0

`init.start[Td]` start Td = 23.0

`init.start[Tz_BRD]` start Tz_BRD = 5.0

`init.start[Sp]` start Sp = 17.0

`init.start[X_BRD_MLK]` start X_BRD_MLK = 8.0

`init.start[pe_MLK]` start pe_MLK = 1.0

`init.start[pq_MLK]` start pq_MLK = 1.0

`init.start[Y_MLK]` start Y_MLK = 52.0

`init.start[Tz_MLK]` start Tz_MLK = 4.0

`init.start[pq_BRD]` start pq_BRD = 1.0

`init.start[pf_CAP]` start pf_CAP = 1.0

`init.start[Xg_BRD]` start Xg_BRD = 19.0

`init.start[Xv_MLK]` start Xv_MLK = 15.0

`init.start[M_MLK]` start M_MLK = 11.0

`init.start[E_BRD]` start E_BRD = 8.0

`init.start[Xp_BRD]` start Xp_BRD = 20.0

`init.start[py_MLK]` start py_MLK = 1.0

`init.start[Z_BRD]` start Z_BRD = 73.0

`init.start[E_MLK]` start E_MLK = 4.0

`init.start[Tm_MLK]` start Tm_MLK = 2.0

`init.start[epsilon]` start epsilon = 1.0

`init.start[D_BRD]` start D_BRD = 70.0

`init.start[Q_BRD]` start Q_BRD = 84.0

`init.start[pm_MLK]` start pm_MLK = 1.0

`init.start[F_CAP_BRD]` start F_CAP_BRD = 18.0

`init.start[Sg]` start Sg = 2.0

`init.start[py_BRD]` start py_BRD = 1.0

`init.start[Q_MLK]` start Q_MLK = 85.0

`init.start[F_LAB_MLK]` start F_LAB_MLK = 25.0

`init.start[Xv_BRD]` start Xv_BRD = 16.0

`init.start[Xp_MLK]` start Xp_MLK = 30.0

`init.start[pf_LAB]` start pf_LAB = 1.0

`init.start[D_MLK]` start D_MLK = 72.0

`init.start[Z_MLK]` start Z_MLK = 72.0

`init.start[Y_BRD]` start Y_BRD = 33.0

`init.start[pe_BRD]` start pe_BRD = 1.0

`init.lower[X_MLK_BRD]` lower X_MLK_BRD = 1.0e-5

`init.lower[F_LAB_BRD]` lower F_LAB_BRD = 1.0e-5

`init.lower[X_MLK_MLK]` lower X_MLK_MLK = 1.0e-5

`init.lower[pd_MLK]` lower pd_MLK = 1.0e-5

`init.lower[F_CAP_MLK]` lower F_CAP_MLK = 1.0e-5

`init.lower[pz_MLK]` lower pz_MLK = 1.0e-5

`init.lower[pz_BRD]` lower pz_BRD = 1.0e-5

`init.lower[Xg_MLK]` lower Xg_MLK = 1.0e-5

`init.lower[pm_BRD]` lower pm_BRD = 1.0e-5

`init.lower[X_BRD_BRD]` lower X_BRD_BRD = 1.0e-5

`init.lower[Tm_BRD]` lower Tm_BRD = 0.0

`init.lower[pd_BRD]` lower pd_BRD = 1.0e-5

`init.lower[Td]` lower Td = 1.0e-5

`init.lower[M_BRD]` lower M_BRD = 1.0e-5

`init.lower[Tz_BRD]` lower Tz_BRD = 0.0

`init.lower[Sp]` lower Sp = 1.0e-5

`init.lower[X_BRD_MLK]` lower X_BRD_MLK = 1.0e-5

`init.lower[pe_MLK]` lower pe_MLK = 1.0e-5

`init.lower[pq_MLK]` lower pq_MLK = 1.0e-5

`init.lower[Y_MLK]` lower Y_MLK = 1.0e-5

`init.lower[Tz_MLK]` lower Tz_MLK = 0.0

`init.lower[pq_BRD]` lower pq_BRD = 1.0e-5

`init.lower[pf_CAP]` lower pf_CAP = 1.0e-5

`init.lower[Xg_BRD]` lower Xg_BRD = 1.0e-5

`init.lower[Xv_MLK]` lower Xv_MLK = 1.0e-5

`init.lower[M_MLK]` lower M_MLK = 1.0e-5

`init.lower[E_BRD]` lower E_BRD = 1.0e-5

`init.lower[Xp_BRD]` lower Xp_BRD = 1.0e-5

`init.lower[py_MLK]` lower py_MLK = 1.0e-5

`init.lower[Z_BRD]` lower Z_BRD = 1.0e-5

`init.lower[E_MLK]` lower E_MLK = 1.0e-5

`init.lower[Tm_MLK]` lower Tm_MLK = 0.0

`init.lower[epsilon]` lower epsilon = 1.0e-5

`init.lower[D_BRD]` lower D_BRD = 1.0e-5

`init.lower[Q_BRD]` lower Q_BRD = 1.0e-5

`init.lower[pm_MLK]` lower pm_MLK = 1.0e-5

`init.lower[F_CAP_BRD]` lower F_CAP_BRD = 1.0e-5

`init.lower[Sg]` lower Sg = 1.0e-5

`init.lower[py_BRD]` lower py_BRD = 1.0e-5

`init.lower[Q_MLK]` lower Q_MLK = 1.0e-5

`init.lower[F_LAB_MLK]` lower F_LAB_MLK = 1.0e-5

`init.lower[Xv_BRD]` lower Xv_BRD = 1.0e-5

`init.lower[Xp_MLK]` lower Xp_MLK = 1.0e-5

`init.lower[pf_LAB]` lower pf_LAB = 1.0e-5

`init.lower[D_MLK]` lower D_MLK = 1.0e-5

`init.lower[Z_MLK]` lower Z_MLK = 1.0e-5

`init.lower[Y_BRD]` lower Y_BRD = 1.0e-5

`init.lower[pe_BRD]` lower pe_BRD = 1.0e-5

`numeraire.numeraire` numeraire fixed
