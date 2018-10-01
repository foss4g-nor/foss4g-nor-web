import React from "react";

import styles from "./footerStyles.module.css";

const Footer = () => {
  return (
    <div className={styles.footer}>
      <div className={styles.footerContainer}>
        <p>
           Faggruppen Geografisk IT i GeoForum 2018 | Siden er inspirert av <a href="https://github.com/amandeepmittal/gatsby-portfolio-v3">Aman Mittal</a> 
        </p>
      </div>
    </div>
  );
};

export default Footer;
