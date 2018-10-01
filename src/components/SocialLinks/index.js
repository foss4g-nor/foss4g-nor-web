import React from "react";
import { FaEnvelope, FaTwitter } from "react-icons/lib/fa";

import styles from "./socialLinksStyles.module.css";

const SocialLinks = () => {
  return (
    <div className={styles.socialLinks}>
      <ul>
        <li>
          <a href="mailto:foss4gno@gmail.com">
            <FaEnvelope />
          </a>
        </li>
        <li>
          <a href="https://twitter.com/GeografiskIT">
            <FaTwitter />
          </a>
        </li>
      </ul>
    </div>
  );
};

export default SocialLinks;
