⚠️ ATTENTION : Ce script utilise exclusivement la commande sudo. Pour garantir une exécution correcte, veuillez lancer le script depuis un utilisateur standard (non-root) possédant les privilèges sudo. L'exécution directe en tant que compte root pur n'est pas recommandée.

# HardConfDebian - Script de durcissement Debian

## 🎯 Objectif
Automatiser l'application des recommandations de sécurité ANSSI BP-028 
pour sensibiliser la communauté Debian au hardening.

## 📚 Références
- [ANSSI BP-028 v2.0](https://cyber.gouv.fr/publications/configuration-recommendations-gnulinux-system)
- Niveaux de durcissement : Minimal → Intermédiaire → Renforcé → Élevé

## ⚙️ Ce que fait le script

### Outils installés
- **CrowdSec** : IPS/IDS communautaire
- **UFW** : Pare-feu simplifié
- **ClamAV** : Antivirus
- **AIDE** : Détection d'intrusion par intégrité fichiers
- **AppArmor** : Confinement applicatif (MAC)
- **Rkhunter** : Détection de rootkits

### Modes de hardening kernel
- **STRICT** : Niveau ANSSI "Renforcé/Élevé" (désactive IPv6, ptrace strict)
- **STANDARD** : Niveau ANSSI "Minimal/Intermédiaire"

## ⚠️ Prérequis CRITIQUES
- ✅ Testez sur VM avant production
- ✅ Ayez un accès console (pas seulement SSH)
- ✅ Sauvegardez vos données
- ✅ Lisez le code avant exécution

## 🚀 Utilisation
```bash
chmod +x hardconf.sh
./hardconf.sh