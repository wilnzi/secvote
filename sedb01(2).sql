-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le :  lun. 10 fév. 2020 à 16:29
-- Version du serveur :  10.4.8-MariaDB
-- Version de PHP :  7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `sedb01`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `loadCountingTable` ()  BEGIN

	
 
	START TRANSACTION;
	
	CALL removeOldCountingData();
	
	INSERT INTO t_decompte(code_electeur, empreinte, valeur_chiffree, ordre_cle)
		
	SELECT vn.code_electeur AS code_electeur, vc.empreinte AS empreinte,  vc.valeur AS valeur_chiffree, vc.ordre_cle AS ordre_cle
	FROM vote AS vn
	INNER JOIN vote_chiffre AS vc 
	ON vn.empreinte = vc.empreinte  AND vc.etat = 1 
	;
	COMMIT;
	
	SELECT COUNT(*) AS elementNumber 
	FROM t_decompte
	WHERE actif = 1;
	

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `removeOldCountingData` ()  BEGIN 
	-- START TRANSACTION;
	
		-- UPDATE t_decompte 
		-- SET actif = 0,
		-- dmaj = NOW()
		-- WHERE actif = 1; 
		
		TRUNCATE TABLE t_decompte;
		TRUNCATE TABLE t_decompte_simplifie;
		TRUNCATE TABLE t_decompte_final;

	-- COMMIT;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `bureau_vote_electronique`
--

CREATE TABLE `bureau_vote_electronique` (
  `id_bureau_vote_electronique` int(11) NOT NULL,
  `code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `candidat`
--

CREATE TABLE `candidat` (
  `id_candidat` int(11) NOT NULL,
  `pseudo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code_candidat` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parti_politique` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ordre` smallint(6) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `candidat`
--

INSERT INTO `candidat` (`id_candidat`, `pseudo`, `code_candidat`, `parti_politique`, `ordre`, `checksum`) VALUES
(1, 'titi', 'titi', 'TITI', 1, NULL),
(2, 'tutu', 'tutu', 'TUTU', 2, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `code_electeur`
--

CREATE TABLE `code_electeur` (
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_bureau_vote_electronique` int(11) NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `electeur`
--

CREATE TABLE `electeur` (
  `id_electeur` int(11) NOT NULL,
  `id_bureau_vote_electronique` int(11) NOT NULL,
  `pseudo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_carte` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'numéro de carte électeur, utile si le système peut être associé à un système de vote physique',
  `statut_vote` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'définit si l''électeur a déjà voté. 0= il n''a pas encore voté, 1 sinon',
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `hash`
--

CREATE TABLE `hash` (
  `code_hash` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'clé de hachage d''un électeur',
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `juge_anonymat`
--

CREATE TABLE `juge_anonymat` (
  `id_juge_anonymat` int(11) NOT NULL,
  `id_candidat` int(11) NOT NULL,
  `pseudo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ordre` smallint(6) NOT NULL,
  `code_juge` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `etat_envoie` tinyint(4) NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `melange`
--

CREATE TABLE `melange` (
  `empreinte_melange` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valeur` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'valeur chiffrée du bulletin de vote',
  `etat` smallint(6) DEFAULT NULL,
  `ordre_cle` tinyint(4) DEFAULT NULL COMMENT 'Ordre de la clé de chiffrement utilisée',
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personne`
--

CREATE TABLE `personne` (
  `id_personne` int(11) NOT NULL,
  `age` smallint(6) DEFAULT NULL,
  `email` char(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prenom` char(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nom` char(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telephone` char(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personne`
--

INSERT INTO `personne` (`id_personne`, `age`, `email`, `prenom`, `nom`, `telephone`, `checksum`) VALUES
(1, 31, 'candi1@candi.fr', 'TITI', 'TITI', '6XXXXXXXX', NULL),
(2, 30, 'candi2@candi.fr', 'TUTU', 'TUTU', '6YYYYYYYY', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `session`
--

CREATE TABLE `session` (
  `id_session` int(11) NOT NULL,
  `pseudo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `token` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `t_decompte`
--

CREATE TABLE `t_decompte` (
  `id` int(11) NOT NULL,
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `empreinte` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valeur_chiffree` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'valeur chiffrée du bulletin de vote',
  `ordre_cle` tinyint(4) NOT NULL DEFAULT 0 COMMENT 'Ordre de la clé de chiffrement utilisée',
  `valeur_dechiffree` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NULL',
  `etat` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Définit si le vote est utilisable',
  `actif` int(1) NOT NULL DEFAULT 1,
  `dcre` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Date de création',
  `dmaj` datetime DEFAULT NULL COMMENT 'Date de mise à jour'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `t_decompte`
--

INSERT INTO `t_decompte` (`id`, `code_electeur`, `empreinte`, `valeur_chiffree`, `ordre_cle`, `valeur_dechiffree`, `etat`, `actif`, `dcre`, `dmaj`) VALUES
(1, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'AUMe/lkAfICsjgTHdxC2yQ==', 1, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(2, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'uzvbqUWy8wwCwA2E/GDBCg==', 2, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(3, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', '2CW/jFdDD84/uEgYZeh3JQ==', 3, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(4, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'YgJvi79pZH84ipOUYCaGeg==', 4, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(5, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', '/UDBe1Mi/AxVOpzBNDu9Aw==', 5, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(6, 'NCW', 'fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'U28HNeyrKu1VOGbhoyzIFQ==', 6, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(7, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'XG1/+hhjKrrqllWwDR56bg==', 1, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(8, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'HHXHPOzuox/i1jxuMI84Lw==', 2, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(9, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'LKNBvaZG5igdtquvEPkeAA==', 3, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(10, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'e5t1zzMKbaVA46Hm/nOEog==', 4, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(11, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'vlGfPn0Z2BF0o0NzvBMEXw==', 5, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(12, 'NYS', '5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', '5sKMoirfwClb7wPwBV6Qaw==', 6, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(13, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'AUMe/lkAfICsjgTHdxC2yQ==', 1, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(14, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'uzvbqUWy8wwCwA2E/GDBCg==', 2, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(15, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', '2CW/jFdDD84/uEgYZeh3JQ==', 3, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(16, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'YgJvi79pZH84ipOUYCaGeg==', 4, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(17, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', '/UDBe1Mi/AxVOpzBNDu9Aw==', 5, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(18, 'NYS', '086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'U28HNeyrKu1VOGbhoyzIFQ==', 6, 'tutu', 1, 1, '2020-02-10 16:23:01', NULL),
(19, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'XG1/+hhjKrrqllWwDR56bg==', 1, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(20, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'HHXHPOzuox/i1jxuMI84Lw==', 2, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(21, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'LKNBvaZG5igdtquvEPkeAA==', 3, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(22, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'e5t1zzMKbaVA46Hm/nOEog==', 4, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(23, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'vlGfPn0Z2BF0o0NzvBMEXw==', 5, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(24, 'NCW', 'c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', '5sKMoirfwClb7wPwBV6Qaw==', 6, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(25, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'XG1/+hhjKrrqllWwDR56bg==', 1, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(26, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'HHXHPOzuox/i1jxuMI84Lw==', 2, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(27, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'LKNBvaZG5igdtquvEPkeAA==', 3, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(28, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'e5t1zzMKbaVA46Hm/nOEog==', 4, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(29, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'vlGfPn0Z2BF0o0NzvBMEXw==', 5, 'titi', 1, 1, '2020-02-10 16:23:01', NULL),
(30, 'NYS', 'd3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', '5sKMoirfwClb7wPwBV6Qaw==', 6, 'titi', 1, 1, '2020-02-10 16:23:01', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `t_decompte_final`
--

CREATE TABLE `t_decompte_final` (
  `id` int(11) NOT NULL,
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `candidat` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NULL',
  `dcre` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Date de création'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `t_decompte_final`
--

INSERT INTO `t_decompte_final` (`id`, `code_electeur`, `candidat`, `dcre`) VALUES
(1, 'NYS', 'titi', '2020-02-10 16:23:02');

-- --------------------------------------------------------

--
-- Structure de la table `t_decompte_simplifie`
--

CREATE TABLE `t_decompte_simplifie` (
  `id` int(11) NOT NULL,
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valeur_dechiffree` text COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NULL',
  `dcre` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'Date de création'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `t_decompte_simplifie`
--

INSERT INTO `t_decompte_simplifie` (`id`, `code_electeur`, `valeur_dechiffree`, `dcre`) VALUES
(1, 'NYS', 'tutu', '2020-02-10 16:23:02'),
(2, 'NYS', 'titi', '2020-02-10 16:23:02'),
(3, 'NCW', 'titi', '2020-02-10 16:23:02'),
(4, 'NYS', 'titi', '2020-02-10 16:23:02'),
(5, 'NCW', 'tutu', '2020-02-10 16:23:02');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `pseudo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_personne` int(11) NOT NULL,
  `mot_passe` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`pseudo`, `id_personne`, `mot_passe`, `checksum`) VALUES
('titi', 1, 'cce66316b4c1c59df94a35afb80cecd82d1a8d91b554022557e115f5c275f515', NULL),
('tutu', 2, 'eb0295d98f37ae9e95102afae792d540137be2dedf6c4b00570ab1d1f355d033', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `vote`
--

CREATE TABLE `vote` (
  `empreinte` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code_electeur` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `etat` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Détermine si ce vote est valide 1 si oui et 0 si non',
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `vote`
--

INSERT INTO `vote` (`empreinte`, `code_electeur`, `etat`, `checksum`) VALUES
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'NYS', 1, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'NYS', 1, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'NCW', 1, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'NYS', 1, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'NCW', 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `vote_chiffre`
--

CREATE TABLE `vote_chiffre` (
  `empreinte` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valeur` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'valeur chiffrée du bulletin de vote',
  `etat` smallint(6) DEFAULT NULL,
  `ordre_cle` tinyint(4) DEFAULT NULL COMMENT 'Ordre de la clé de chiffrement utilisée',
  `checksum` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `vote_chiffre`
--

INSERT INTO `vote_chiffre` (`empreinte`, `valeur`, `etat`, `ordre_cle`, `checksum`) VALUES
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'AUMe/lkAfICsjgTHdxC2yQ==', 1, 1, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'uzvbqUWy8wwCwA2E/GDBCg==', 1, 2, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', '2CW/jFdDD84/uEgYZeh3JQ==', 1, 3, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'YgJvi79pZH84ipOUYCaGeg==', 1, 4, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', '/UDBe1Mi/AxVOpzBNDu9Aw==', 1, 5, NULL),
('fe2fe1807f27f65b9c30c90d15391f3a7471cfa4d7f436ced5754247b98b36aa6b90545d645feeeae88f5fffe89be537', 'U28HNeyrKu1VOGbhoyzIFQ==', 1, 6, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'XG1/+hhjKrrqllWwDR56bg==', 1, 1, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'HHXHPOzuox/i1jxuMI84Lw==', 1, 2, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'LKNBvaZG5igdtquvEPkeAA==', 1, 3, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'e5t1zzMKbaVA46Hm/nOEog==', 1, 4, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', 'vlGfPn0Z2BF0o0NzvBMEXw==', 1, 5, NULL),
('5f9acc5e20af65a1583ab805a4f3818a79a63af2806287f07f1a800583f7ebdb1302c6da712ff0d0cfb525438ad0c256', '5sKMoirfwClb7wPwBV6Qaw==', 1, 6, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'AUMe/lkAfICsjgTHdxC2yQ==', 1, 1, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'uzvbqUWy8wwCwA2E/GDBCg==', 1, 2, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', '2CW/jFdDD84/uEgYZeh3JQ==', 1, 3, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'YgJvi79pZH84ipOUYCaGeg==', 1, 4, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', '/UDBe1Mi/AxVOpzBNDu9Aw==', 1, 5, NULL),
('086d2f735ed336d92c1c1e51c3871c139074eed40776ae1803857dd6f2a762d0245a703d27438fc7cea031c6a1398f45', 'U28HNeyrKu1VOGbhoyzIFQ==', 1, 6, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'XG1/+hhjKrrqllWwDR56bg==', 1, 1, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'HHXHPOzuox/i1jxuMI84Lw==', 1, 2, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'LKNBvaZG5igdtquvEPkeAA==', 1, 3, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'e5t1zzMKbaVA46Hm/nOEog==', 1, 4, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', 'vlGfPn0Z2BF0o0NzvBMEXw==', 1, 5, NULL),
('c1614046ee25988603cb8abe27263c9537e92b1c75a533fd10e6964ec814dd4dfacfbb2bc9954307cf3ce99422429d5f', '5sKMoirfwClb7wPwBV6Qaw==', 1, 6, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'XG1/+hhjKrrqllWwDR56bg==', 1, 1, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'HHXHPOzuox/i1jxuMI84Lw==', 1, 2, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'LKNBvaZG5igdtquvEPkeAA==', 1, 3, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'e5t1zzMKbaVA46Hm/nOEog==', 1, 4, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', 'vlGfPn0Z2BF0o0NzvBMEXw==', 1, 5, NULL),
('d3e7158eb586b67771465230b4fbb07e57bd71022b7dd0820a29bc27844137ce47d7940128db30f1b321afccf13987de', '5sKMoirfwClb7wPwBV6Qaw==', 1, 6, NULL);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_decompte`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_decompte` (
`id` int(11)
,`code_electeur` varchar(200)
,`empreinte` varchar(200)
,`valeur_chiffree` text
,`ordre_cle` tinyint(4)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `v_decompte_simplifie`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `v_decompte_simplifie` (
`code_electeur` varchar(200)
,`candidat` text
,`nombre_vote` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure de la vue `v_decompte`
--
DROP TABLE IF EXISTS `v_decompte`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_decompte`  AS  select `t_decompte`.`id` AS `id`,`t_decompte`.`code_electeur` AS `code_electeur`,`t_decompte`.`empreinte` AS `empreinte`,`t_decompte`.`valeur_chiffree` AS `valeur_chiffree`,`t_decompte`.`ordre_cle` AS `ordre_cle` from `t_decompte` where `t_decompte`.`actif` = 1 ;

-- --------------------------------------------------------

--
-- Structure de la vue `v_decompte_simplifie`
--
DROP TABLE IF EXISTS `v_decompte_simplifie`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_decompte_simplifie`  AS  select `t_decompte_simplifie`.`code_electeur` AS `code_electeur`,`t_decompte_simplifie`.`valeur_dechiffree` AS `candidat`,count(0) AS `nombre_vote` from `t_decompte_simplifie` group by `t_decompte_simplifie`.`code_electeur`,`t_decompte_simplifie`.`valeur_dechiffree` order by `t_decompte_simplifie`.`code_electeur`,count(0) desc ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `bureau_vote_electronique`
--
ALTER TABLE `bureau_vote_electronique`
  ADD PRIMARY KEY (`id_bureau_vote_electronique`);

--
-- Index pour la table `candidat`
--
ALTER TABLE `candidat`
  ADD PRIMARY KEY (`id_candidat`);

--
-- Index pour la table `code_electeur`
--
ALTER TABLE `code_electeur`
  ADD PRIMARY KEY (`code_electeur`);

--
-- Index pour la table `electeur`
--
ALTER TABLE `electeur`
  ADD PRIMARY KEY (`id_electeur`);

--
-- Index pour la table `hash`
--
ALTER TABLE `hash`
  ADD PRIMARY KEY (`code_hash`);

--
-- Index pour la table `juge_anonymat`
--
ALTER TABLE `juge_anonymat`
  ADD PRIMARY KEY (`id_juge_anonymat`);

--
-- Index pour la table `melange`
--
ALTER TABLE `melange`
  ADD PRIMARY KEY (`empreinte_melange`);

--
-- Index pour la table `personne`
--
ALTER TABLE `personne`
  ADD PRIMARY KEY (`id_personne`);

--
-- Index pour la table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id_session`);

--
-- Index pour la table `t_decompte`
--
ALTER TABLE `t_decompte`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `empreinte` (`empreinte`,`valeur_chiffree`) USING HASH;

--
-- Index pour la table `t_decompte_final`
--
ALTER TABLE `t_decompte_final`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code_electeur_decompte_final` (`code_electeur`) USING BTREE;

--
-- Index pour la table `t_decompte_simplifie`
--
ALTER TABLE `t_decompte_simplifie`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`pseudo`);

--
-- Index pour la table `vote`
--
ALTER TABLE `vote`
  ADD PRIMARY KEY (`empreinte`);

--
-- Index pour la table `vote_chiffre`
--
ALTER TABLE `vote_chiffre`
  ADD UNIQUE KEY `empreinte` (`empreinte`,`valeur`) USING HASH;

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `candidat`
--
ALTER TABLE `candidat`
  MODIFY `id_candidat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `personne`
--
ALTER TABLE `personne`
  MODIFY `id_personne` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `t_decompte`
--
ALTER TABLE `t_decompte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT pour la table `t_decompte_final`
--
ALTER TABLE `t_decompte_final`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `t_decompte_simplifie`
--
ALTER TABLE `t_decompte_simplifie`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
