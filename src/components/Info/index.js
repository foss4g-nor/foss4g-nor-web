import React from "react";

import Avatar from "../Avatar/index";
import SocialLinks from "../SocialLinks/index";
import styles from "./info.module.css";
import { StaticQuery, graphql } from "gatsby";
import Img from "gatsby-image";

const Info = () => {
  return (
    <div style={{ textAlign: "center" }}>
      <Avatar />
      <div>
        <h3>Open-source programvare i geomatikkbransjen</h3>
        <p >18.oktober 2018</p>
        <p style={{ marginBottom: 30 }}>Felix Konferansesenter, Bryggetorget 3, 0250 Oslo</p>
        <a className={styles.signupBtn} href="https://geoforum.pameldingssystem.no/foss4g-nor">Påmelding</a>
        <SocialLinks />
        <StaticQuery
          query={graphql`
    {
      allFile(filter: {sourceInstanceName: {regex: "/(sponsorimages)/"}}) {
        edges {
          node {
            childImageSharp {
              fixed(height: 50){
                ...GatsbyImageSharpFixed
              }
            }
          }
        }
      }
    }  
    `}
          render={data => {debugger; return(
            <div style={{marginTop: 50, display: "flex",  flexDirection: "column", alignItems: "center" }}>
              {data.allFile.edges.map((edge, i) => <Img key={i} style={{margin: 5, height: 50}}fixed={edge.node.childImageSharp.fixed} />)}
              </div>
          )}} />
      </div>
    </div>
  );
};

export default Info;
