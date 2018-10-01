import React from "react";

import {
  Sides,
  LeftSide,
  RightSideHome
} from "../shared/styles/styled-components";

import Info from "../components/Info";
import TemplateWrapper from "../components/layouts/index";
import Talks from "../components/Talks/index";

const IndexPage = () => (
  <TemplateWrapper>
    <Sides>
      <LeftSide>
        <Info />
      </LeftSide>
      <RightSideHome>
        <Talks/>
      </RightSideHome>
    </Sides>
  </TemplateWrapper>
);

export default IndexPage;
