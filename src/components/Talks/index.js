import React from "react";
import {
  Section,
  SectionTitle,
} from "../../shared/styles/styled-components";
import { StaticQuery, graphql } from "gatsby";
import Img from "gatsby-image";

export default () => (
  <StaticQuery
    query={graphql`
    {
      allProgramCsv {
        edges {
          node {
            Starttidspunkt
            Innlegg
            Taler
            Sammendrag
            Type
            Firma
            Bilde {
              childImageSharp {
                fixed(width: 75, height: 75) {
                  ...GatsbyImageSharpFixed_withWebp_noBase64
                }
              }
            }
          }
        }
      }
    }    
    `}
    render={data => (
      <div>
        {data.allProgramCsv.edges.map((edge,i) => (
                <Section style={{}}key={i} id="who">
                  <h3 style={{marginBottom: -2}}>{"kl. " + edge.node.Starttidspunkt}</h3>
                  <SectionTitle>{edge.node.Innlegg}</SectionTitle>
                  {edge.node.Type === "innlegg" && <div style={{flexDirection: "row", display: "flex"}}>
                  <Img style={{borderRadius: "50%"}} fixed={edge.node.Bilde.childImageSharp.fixed} />
                    <div style={{marginLeft: 20}}>
                      <p style={{fontSize: 18}}>{edge.node.Taler} <br /> {edge.node.Firma}</p>
                    </div>
                  </div>}
                  <p>{edge.node.Sammendrag}</p>
                </Section>
        ))}
      </div>
    )} />
)
